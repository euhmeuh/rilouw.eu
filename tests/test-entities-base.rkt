#lang racket/base

(provide test-entities-base)

(require
  rackunit
  web-galaxy/entities)

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

    (test-case
      "Can overwrite renderers"
      (define my-link (link "More..." "/full/article"))
      (define not-a-link '(span "Nothing here"))
      (check-equal? (parameterize ([render-link (lambda (link) not-a-link)])
                      (render-element my-link))
                    not-a-link))

    (test-case
      "Publication dates should render as <time>"
      (define my-date (pubdate 2018 2 16))
      (check-equal? (render-element my-date)
                    '(time ([datetime "2018-02-16"]) "Friday, February 16, 2018")))

    ))
