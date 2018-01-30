#lang racket/base

(provide render-article)

(require
  "_base.rkt"
  "_blog.rkt"
  "../entities/blog.rkt")

(define (render-article article)
    (render-base (article-title article) '()
      (lambda ()
        `(main
           (article
             (h2 ([id ,(article-id article)]) ,(article-title article))
             ,@(render-elements article))))))
