#lang racket/base

(provide
  not-found-page)

(require
  "_base.rkt"
  (only-in "../l10n/locale.rkt" loc))

(define (not-found-page db)
  (base-page db "404" '()
    (lambda ()
      `(main (p ,(loc error-404))))))
