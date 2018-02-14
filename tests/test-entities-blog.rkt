#lang racket/base

(provide test-entities-blog)

(require
  rackunit
  "../entities/blog.rkt")

(define test-entities-blog
  (test-suite
    "Blog entities & renderers"

    (test-case
      "Fold should render as <hr>"

      (define my-fold (fold))
      (check-equal? (render-element my-fold)
                    '(hr)))

    ))
