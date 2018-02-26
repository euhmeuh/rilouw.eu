#lang racket/base

(provide
  error-page)

(require
  "_base.rkt")

(define (error-page db)
  (base-page db "500" '()
    (lambda ()
      '(main (p "500 Internal server error - The request you made failed. Are you a pirate?")))))
