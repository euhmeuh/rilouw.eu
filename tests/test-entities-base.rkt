#lang racket/base

(provide test-entities-base)

(require
  rackunit
  "../entities/base.rkt")

(define test-entities-base
  (test-suite
    "Tests base entities"

    (test-case
      "Test macro define-renderer"

      (define-renderer link (text url)
        `(a ([href ,(link-url link)]) ,(link-text link)))

      )))
