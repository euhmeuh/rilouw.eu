#lang racket/base

(provide
  (all-from-out "base.rkt")

  load-article

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
  (walk-and-set-section-ids!
    (article body (normalize title) title tags)))

(define (make-paragraph . text-or-links)
  (paragraph text-or-links))

(define (make-section title . elements)
  (section elements (normalize title) title))

(define (make-note . elements)
  (note elements))

(define (make-dotted-list . elements)
  (dotted-list elements))

(define (walk-and-set-section-ids! article)
  (for-each
    (lambda (element)
      (when (section? element)
        (set-section-id! element (string-append (article-id article)
                                                "-"
                                                (section-id element)))))
    (container-elements article))
  article)

(define (normalize str)
  (string-downcase
    (string-normalize-spaces str #rx"[^a-zA-Z0-9]+" "-")))

(define (load-article path)
  (dynamic-require path 'article))
