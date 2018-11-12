#lang racket/base

(provide
  not-found-page)

(require
  rilouw-website/pages/base
  (only-in web-galaxy/translate tr))

(define (not-found-page db)
  (base-page db "404" '()
    (lambda ()
      `(main (p ,(tr error-404))))))
