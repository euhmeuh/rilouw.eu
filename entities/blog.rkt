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

  (except-out (struct-out section) section)
  (rename-out [make-section section])
  render-section

  (except-out (struct-out note) note)
  (rename-out [make-note note])
  render-note

  (except-out (struct-out project) project)
  (rename-out [make-project project])

  (except-out (struct-out event) event)
  (rename-out [make-event event])

  (except-out (struct-out talk) talk)
  (rename-out [make-talk talk])

  (struct-out inline-code)
  render-inline-code

  (except-out (struct-out code) code)
  (rename-out [make-code code])
  render-code

  (except-out (struct-out console) console)
  (rename-out [make-console console])
  render-console

  (except-out (struct-out dotted-list) dotted-list)
  (rename-out [make-dotted-list dotted-list])
  render-dotted-list

  (except-out (struct-out lquote) lquote)
  (rename-out [make-lquote lquote])
  render-lquote)

(require
  racket/contract
  racket/function
  racket/list
  racket/string
  anaphoric
  web-galaxy/renderer
  web-galaxy/entities
  rilouw-website/entities/urls)

(define (render-tag symbol)
  (render-element (link (make-tag-url symbol)
                        (symbol->string symbol))))

;; --- article ---

(struct article container (id title date tags))

(define (make-article title date tags . body)
  (article body (string->symbol (normalize title)) title date tags))

(define (draft? article)
  (memq 'draft (article-tags article)))

(define (before-the-fold article)
  (define elements (container-elements article))
  (if (findf fold? elements)
    (takef elements
           (not/c fold?))
    (take elements 1)))

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

;; --- project ---

(struct project container (id name date desc logo discontinued? links))

(define (make-project #:name name
                      #:date date
                      #:desc desc
                      #:logo [logo #f]
                      #:discontinued? [discontinued? #f]
                      #:links [links '()]
                      . body)
  (project body
           (string->symbol (normalize name))
           name
           date
           desc
           logo
           discontinued?
           links))

(define-renderer fold () `(hr))

;; --- talk ---

(struct event (name date-start date-end))

(define (make-event #:name name
                    #:dates dates)
  (event name (car dates) (cdr dates)))

(struct talk (name desc event links))

(define (make-talk #:name name
                   #:desc desc
                   #:event event
                   #:links links)
  (talk name desc event links))

;; --- misc ---

(define-renderer inline-code (text)
  `(code ([class "inline"]) ,(inline-code-text inline-code)))

(define-renderer code (title language text)
  `(div ([class "code"])
     (div ([class "header"])
       (div ([class "width-50"]) ,(code-title code))
       (div ([class "width-50 language"]) ,(code-language code)))
     (pre (code ,(code-text code)))))

(define (make-code title language . text)
  (code title language (string-join text "")))

(define-renderer console (title text)
  `(div ([class "console"])
     (div ([class "title"]) ,(console-title console))
     (pre (code ,(console-text console)))))

(define (make-console title . text)
  (console title (string-join text "")))

(define-renderer dotted-list container ()
  `(ul ,@(map (lambda (element)
                `(li ,(render-element element)))
              (container-elements dotted-list))))

(define (make-dotted-list . elements)
  (dotted-list elements))

(define-renderer lquote container (author date source)
  `(figure ([class "quote"])
     (blockquote ,@(render-elements lquote))
     (figcaption
       (div ([class "author"]) ,(lquote-author lquote))
       (div ,(render-element (lquote-date lquote)))
       (cite ,(lquote-source lquote)))))

(define (make-lquote author date source . elements)
  (lquote elements author date source))

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
