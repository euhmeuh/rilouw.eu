#lang racket/base

(require
  rackunit
  rackunit/text-ui
  "test-entities-base.rkt"
  "test-entities-blog.rkt")

(run-tests
  (test-suite
    "All tests"
    test-entities-base
    test-entities-blog))
