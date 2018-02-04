#lang racket/base

(provide
  article-page)

(require
  "_base.rkt"
  "../entities/blog.rkt")

(define (article-page db article)
  (base-page db (article-title article) '()
    (lambda ()
      `(main
         (article
           (h2 ([id ,(article-id article)]) ,(article-title article))
           ,@(render-elements article))))))
