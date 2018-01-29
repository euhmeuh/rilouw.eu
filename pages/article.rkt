#lang racket/base

(provide render-article)

(require
  "_base.rkt"
  "../entities/blog.rkt")

(define (render-article article)
  (render-base (article-title article) '()
    (lambda ()
      `(main (p ,(article-title article))))))
