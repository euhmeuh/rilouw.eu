#lang racket/base

(provide test-entities-blog)

(require
  racket/list
  rackunit
  "../entities/blog.rkt")

(define test-entities-blog
  (test-suite
    "Blog entities & renderers"

    (test-suite
      "The fold"

      (test-case
        "Fold should render as <hr>"

        (define my-fold (fold))
        (check-equal? (render-element my-fold)
                      '(hr)))

      (test-case
        "Find elements before the fold"

        (define my-article
          (article "I like ponies" '(draft ponies)
            (paragraph "Hey, did you know I liked ponies?")
            (paragraph "They're so cool and fluffy.")
            (paragraph "Want to know more? Check out after the fold!")
            (fold)
            (paragraph "They have a rainbow mane.")
            (paragraph "And they dash through the sky!")))

        (define found-elements (before-the-fold my-article))
        (check-equal? (length found-elements) 3))

      (test-case
        "Get the first element if there is no fold"

        (define first-paragraph (paragraph "There's no fold here?"))
        (define my-article
          (article "Hey" '()
            first-paragraph
            (paragraph "Nope, I'm fine, thanks.")))
        (check-equal? (before-the-fold my-article)
                      first-paragraph))
    )))
