#lang racket/base

(provide render-404)

(require "_base.rkt")

(define (render-404)
  (render-base "404" '()
    (lambda ()
      '(main (p "(404 Not found)")))))
