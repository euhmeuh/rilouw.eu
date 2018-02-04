#lang racket/base

(provide
  make-article-url
  make-tag-url)

(define (make-article-url article-id)
  (format "/article/~a" article-id))

(define (make-tag-url symbol)
  (format "/tag/~a" symbol))
