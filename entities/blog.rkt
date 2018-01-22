#lang racket/base

(provide
  (all-from-out "base.rkt")

  ;; public interface gives only access to special constructors,
  ;; predicates and some accessors
  element-indent
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
  note?)

(require
  racket/string
  racket/function
  "base.rkt")

(struct element ([indent #:mutable]))
(struct container element (elements))

(struct article container (id title))
(struct paragraph container ())
(struct section container ([id #:mutable] title))
(struct note container ())

(define (make-article title . body)
  (walk-and-set-indents!
    (walk-and-set-section-ids!
      (article 0 body (normalize title) title))))

(define (make-paragraph . text-or-links)
  (paragraph 0 text-or-links))

(define (make-section title . elements)
  (section 0 elements (normalize title) title))

(define (make-note . elements)
  (paragraph 0 elements))

(define (walk-and-set-indents! element [indent 0])
  (when (element? element)
    (set-element-indent! element indent))
  (when (container? element)
    (for-each (curryr walk-and-set-indents! (add1 indent))
              (container-elements element)))
  element)

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
