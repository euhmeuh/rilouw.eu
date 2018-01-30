#lang racket/base

(provide render-index)

(require
  racket/list
  "_base.rkt"
  "_blog.rkt"
  "../entities/blog.rkt")

(define (make-article-url article-id)
  (format "/article/~a" article-id))

(define (render-article-preview article)
  (define full-article-link
    (paragraph (link "Full article..." (make-article-url (article-id article)))))
  `(article
     (h2 ([id ,(article-id article)]) ,(article-title article))
     ,(render-element (first (container-elements article)))
     ,(render-paragraph full-article-link)))

(define (render-articles articles)
  (define separator '(hr ([class "fancy"])))
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (article-title article)
        (format "#~a" (article-id article))))

(define (render-index articles)
  (define article-links (map article->link articles))
  (define links (append article-links (list (link "About" "#about"))))
  (render-base "Hello Rilouw!" links
    (lambda ()
      `(main ,@(render-articles articles)))))
