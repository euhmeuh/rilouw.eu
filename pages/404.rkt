#lang racket/base

(provide
  not-found-page)

(require
  "_base.rkt")

(define (not-found-page db)
  (base-page db "404" '()
    (lambda ()
      '(main (p "404 Not found - The page you are looking for does not exist. Sorry :(")))))
