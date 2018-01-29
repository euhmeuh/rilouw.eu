#lang racket/base

(provide
  (all-from-out "base.rkt")

  ;; public interface gives only access to special constructors,
  ;; predicates and some accessors
  container?
  container-elements
  (rename-out [make-article article])
  article?
  article-id
  article-title
  (rename-out [make-paragraph paragraph])
  paragraph?
  (rename-out [make-section section])
  section?
  section-id
  section-title
  (rename-out [make-note note])
  note?
  (rename-out [make-dotted-list dotted-list])
  dotted-list?
  )

(require
  racket/string
  racket/function
  "base.rkt")

(struct container (elements))
(struct article container (id title tags))
(struct paragraph container ())
(struct section container ([id #:mutable] title))
(struct note container ())
(struct dotted-list container ())

(define (make-article title tags . body)
  (define the-article (article body (normalize title) title tags))
  (walk-and-set-section-ids! (article-id the-article)
                             (container-elements the-article))
  the-article)

(define (make-paragraph . text-or-links)
  (paragraph text-or-links))

(define (make-section title . elements)
  (section elements (normalize title) title))

(define (make-note . elements)
  (note elements))

(define (make-dotted-list . elements)
  (dotted-list elements))

(define (walk-and-set-section-ids! id elements)
  (for-each
    (lambda (element)
      (cond
        [(section? element)
         (let ([id (string-append id "-" (section-id element))])
           (set-section-id! element id)
           (walk-and-set-section-ids! id (container-elements element)))]
        [(container? element)
         (walk-and-set-section-ids! id (container-elements element))]))
    elements))

(define (normalize str)
  (string-downcase
    (string-normalize-spaces str #rx"[^a-zA-Z0-9]+" "-")))