#lang racket/base

(require
  rackunit/text-ui
  "test-entities-base.rkt"
  "test-entities-blog.rkt")
 
(run-tests test-entities-base 'verbose)
(run-tests test-entities-blog 'verbose)
