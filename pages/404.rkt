#lang racket/base

(provide render-404)

(require "_base.rkt")

(define (render-404 tags)
  (render-base "404" '() tags
    (lambda ()
      '(main (p "(404 Not found)")))))
