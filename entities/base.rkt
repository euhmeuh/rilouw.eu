#lang racket/base

(provide
  (struct-out link)
  newline)

(struct link (text url))

(define (newline)
  '(br))
