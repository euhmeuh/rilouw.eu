#lang racket/base

(provide
  error-page)

(require
  rilouw-website/pages/base
  (only-in web-galaxy/translate tr))

(define (error-page db)
  (base-page db "500" '()
    (lambda ()
      `(main (p ,(tr error-500))))))
