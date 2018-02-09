#lang racket/base

(provide
  (all-from-out "base.rkt")

  ;; public interface gives only access to special constructors,
  ;; predicates and some accessors
  (rename-out [make-article article])
  article?
  article-id
  article-title
  article-tags

  (struct-out fold)
  render-fold

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
  racket/string
  racket/function
  "base.rkt")

(struct article container (id title tags))

(define (make-article title tags . body)
  (define the-article (article body (normalize title) title tags))
  (walk-and-set-section-ids! (article-id the-article) the-article)
  the-article)

(define (draft? article)
  (memq 'draft (article-tags article)))

(struct fold ()
  #:methods gen:renderer
  [(define (render fold)
     ((render-fold) fold))])

(define render-fold
  (make-parameter (lambda (fold) `(hr))))

(struct paragraph container ()
  #:methods gen:renderer
  [(define (render paragraph)
     ((render-paragraph) paragraph))])

(define (make-paragraph . text-or-links)
  (paragraph text-or-links))

(define render-paragraph
  (make-parameter
    (lambda (paragraph)
      `(p ,@(render-elements paragraph)))))

(struct section container ([id #:mutable] title)
  #:methods gen:renderer
  [(define (render section)
     ((render-section) section))])

(define (make-section title . elements)
  (section elements (normalize title) title))

(define render-section
  (make-parameter
    (lambda (section)
      `(section (h3 ([id ,(section-id section)])
                    ,(section-title section))
                ,@(render-elements section)))))

(struct note container ()
  #:methods gen:renderer
  [(define (render note)
     ((render-note) note))])

(define (make-note . elements)
  (note elements))

(define render-note
  (make-parameter
    (lambda (note)
      `(aside ,@(render-elements note)))))

(struct dotted-list container ()
  #:methods gen:renderer
  [(define (render dotted-list)
     ((render-dotted-list) dotted-list))])

(define (make-dotted-list . elements)
  (dotted-list elements))

(define render-dotted-list
  (make-parameter
    (lambda (dotted-list)
      `(ul ,@(map (lambda (element)
                    `(li ,(render-element element)))
                  (container-elements dotted-list))))))

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
    (string-normalize-spaces str #rx"[^a-zA-Z0-9]+" "-")))
