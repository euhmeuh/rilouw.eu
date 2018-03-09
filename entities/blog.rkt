#lang racket/base

(provide
  (all-from-out "base.rkt")

  ;; public interface gives only access to special constructors,
  ;; predicates and some accessors
  (rename-out [make-article article])
  article?
  article-id
  article-title
  article-date
  article-tags

  (struct-out fold)
  render-fold
  before-the-fold

  (rename-out [make-paragraph paragraph])
  paragraph?
  render-paragraph

  (rename-out [make-section section])
  section?
  section-id
  section-title
  render-section

  (rename-out [make-note note])
  note?
  render-note

  (rename-out [make-dotted-list dotted-list])
  dotted-list?
  render-dotted-list

  ;; is an article a draft?
  draft?)

(require
  racket/contract
  racket/function
  racket/list
  racket/string
  anaphoric
  "base.rkt")

(struct article container (id title date tags))

(define (make-article title date tags . body)
  (define the-article (article body (normalize title) title date tags))
  (walk-and-set-section-ids! (article-id the-article) the-article)
  the-article)

(define (draft? article)
  (memq 'draft (article-tags article)))

(define-renderer fold () `(hr))

(define (before-the-fold article)
  (define elements (container-elements article))
  (if (findf fold? elements)
    (takef elements
           (not/c fold?))
    (take elements 1)))

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

(define (make-dotted-list . elements)
  (dotted-list elements))

(define (walk-and-set-section-ids! id container)
  (for-each
    (lambda (element)
      (cond
        [(section? element)
         (let ([id (string-append id "-" (section-id element))])
           (set-section-id! element id)
           (walk-and-set-section-ids! id element))]
        [(container? element)
         (walk-and-set-section-ids! id element)]))
    (container-elements container)))

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
