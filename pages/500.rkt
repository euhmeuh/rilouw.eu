#lang racket/base

(provide
  error-page)

(require
  "_base.rkt"
  (only-in "../l10n/locale.rkt" loc))

(define (error-page db)
  (base-page db "500" '()
    (lambda ()
      `(main (p ,(loc error-500))))))
