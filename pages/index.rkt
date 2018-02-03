#lang racket/base

(provide render-index)

(require
  racket/list
  "_base.rkt"
  "_blog.rkt"
  "../entities/blog.rkt")

(define (render-article-preview article)
  (define full-article-link
    (paragraph (link "Full article..." (make-article-url (article-id article)))))
  `(article
     (h2 ([id ,(article-id article)]) ,(article-title article))
     ,(render-element (first (container-elements article)))
     ,(render-paragraph full-article-link)))

(define separator '(hr ([class "fancy"])))

(define (render-articles articles)
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (article-title article)
        (format "#~a" (article-id article))))

(define (render-index articles tags [title "Home"])
  (render-base title (map article->link articles) tags
    (lambda ()
      `(main
         (h2 ,title)
         ,separator
         ,@(render-articles articles)))))
