#lang racket/base

(provide
  (all-from-out web-galaxy/entities)

  render-tag

  (except-out (struct-out article) article)
  (rename-out [make-article article])
  draft? ;; is an article a draft?

  (struct-out fold)
  render-fold
  before-the-fold

  (struct-out inline-code)
  render-inline-code

  (except-out (struct-out code) code)
  (rename-out [make-code code])
  render-code

  (except-out (struct-out console) console)
  (rename-out [make-console console])
  render-console

  (rename-out [make-paragraph paragraph])
  paragraph?
  render-paragraph

  (except-out (struct-out section) section)
  (rename-out [make-section section])
  render-section

  (except-out (struct-out note) note)
  (rename-out [make-note note])
  render-note

  (except-out (struct-out lquote) lquote)
  (rename-out [make-lquote lquote])
  render-lquote

  (except-out (struct-out dotted-list) dotted-list)
  (rename-out [make-dotted-list dotted-list])
  render-dotted-list)

(require
  racket/contract
  racket/function
  racket/list
  racket/string
  anaphoric
  web-galaxy/renderer
  web-galaxy/entities
  "urls.rkt")

(define (render-tag symbol)
  (render-element (link (symbol->string symbol)
                        (make-tag-url symbol))))

(struct article container (id title date tags))

(define (make-article title date tags . body)
  (article body (normalize title) title date tags))

(define (draft? article)
  (memq 'draft (article-tags article)))

(define-renderer fold () `(hr))

(define (before-the-fold article)
  (define elements (container-elements article))
  (if (findf fold? elements)
    (takef elements
           (not/c fold?))
    (take elements 1)))

(define-renderer inline-code (text)
  `(code ([class "inline"]) ,(inline-code-text inline-code)))

(define-renderer code (language text)
  (local-require xml)
  `(div ([class "code"])
     (div ([class "language"]) ,(code-language code))
     (pre (code ,(code-text code)))))

(define (make-code language . text)
  (code language (string-join text "")))

(define-renderer console (title text)
  (local-require xml)
  `(div ([class "console"])
     (div ([class "title"]) ,(console-title console))
     (pre (code ,(console-text console)))))

(define (make-console title . text)
  (console title (string-join text "")))

(define-renderer paragraph container ()
  `(p ,@(render-elements paragraph)))

(define (make-paragraph . text-or-links)
  (paragraph text-or-links))

(define-renderer section container ([id #:mutable] title)
  `(section (h3 ([id ,(section-id section)])
                ,(section-title section))
            ,@(render-elements section)))

(define (make-section title . elements)
  (section elements (normalize title) title))

(define-renderer note container ()
  `(aside ,@(render-elements note)))

(define (make-note . elements)
  (note elements))

(define-renderer dotted-list container ()
  `(ul ,@(map (lambda (element)
                `(li ,(render-element element)))
              (container-elements dotted-list))))

(define-renderer lquote container (author date source)
  `(figure ([class "quote"])
     (blockquote ,@(render-elements lquote))
     (figcaption
       (div ([class "author"]) ,(lquote-author lquote))
       (div ,(render-element (lquote-date lquote)))
       (cite ,(lquote-source lquote)))))

(define (make-lquote author date source . elements)
  (lquote elements author date source))

(define (make-dotted-list . elements)
  (dotted-list elements))

(define (normalize str)
  (string-downcase
    (string-normalize-spaces
      (string-normalize-french str)
      #rx"[^a-zA-Z0-9]+" "-")))

(define french-accent-dict
  '([#\a . (#\à #\â)]
    [#\e . (#\é #\è #\ê)]
    [#\i . (#\î #\ï)]
    [#\o . (#\ô #\ö)]
    [#\u . (#\ù #\ü)]
    [#\c . (#\ç)]
    [#\A . (#\À #\Â)]
    [#\E . (#\É #\È #\Ê)]
    [#\I . (#\Î #\Ï)]
    [#\O . (#\Ô #\Ö)]
    [#\U . (#\Ù #\Ü)]
    [#\C . (#\Ç)]))

(define (get-from-dict dict char)
  (for/first ([rule dict]
              #:when (member char (cdr rule)))
    (car rule)))

(define (string-normalize-french str)
  (apply
    string
    (for/list ([char str])
      (aif (get-from-dict french-accent-dict char)
           it
           char))))
