#lang racket/base

(provide
  (all-from-out "base.rkt")
  (struct-out article)
  make-article)

(require
  "base.rkt"
  racket/string)

(struct article (id title body))

(define (make-article title . body)
  (article (normalize title) title body))

(define (normalize str)
  (string-downcase
    (string-normalize-spaces str #rx"[^a-zA-Z0-9]+" "-")))
