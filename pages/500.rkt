#lang racket/base

(provide
  error-page)

(require
  "_base.rkt"
  (only-in web-galaxy/translate tr))

(define (error-page db)
  (base-page db "500" '()
    (lambda ()
      `(main (p ,(tr error-500))))))
