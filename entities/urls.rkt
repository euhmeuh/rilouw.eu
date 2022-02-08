#lang racket/base

(provide
  make-article-url
  make-tag-url)

(define (make-article-url #:full [full #f]
                          article-id)
  (format "~a/article/~a"
          (if full "https://ferale.art" "")
          article-id))

(define (make-tag-url #:full [full #f]
                      symbol)
  (format "~a/tag/~a"
          (if full "https://ferale.art" "")
          symbol))
