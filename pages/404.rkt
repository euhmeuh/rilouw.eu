#lang racket/base

(provide
  not-found-page)

(require
  "_base.rkt"
  (only-in "../l10n/translate.rkt" tr))

(define (not-found-page db)
  (base-page db "404" '()
    (lambda ()
      `(main (p ,(tr error-404))))))
