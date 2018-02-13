#lang racket/base

(provide test-entities-base)

(require
  rackunit
  "../entities/base.rkt")

(define test-entities-base
  (test-suite
    "Base entities & renderers"

    (test-case
      "Links should render as <a> tags"
      (define my-link (link "Click me!" "to/infinity/and/beyond"))
      (check-equal? (link-text my-link) "Click me!")
      (check-equal? (link-url my-link) "to/infinity/and/beyond")
      (check-equal? (render-element my-link)
                    '(a ([href "to/infinity/and/beyond"]) "Click me!")))

    (test-case
      "Symbols should render as links to the tag page"
      (check-equal? (render-element 'ponies)
                    '(a ([href "/tag/ponies"]) "ponies")))

    ))
