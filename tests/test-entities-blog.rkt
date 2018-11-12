#lang racket/base

(provide test-entities-blog)

(require
  racket/list
  rackunit
  rilouw-website/entities/blog)

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
          (article "I like ponies" #f '(draft ponies)
            (p "Hey, did you know I liked ponies?")
            (p "They're so cool and fluffy.")
            (p "Want to know more? Check out after the fold!")
            (fold)
            (p "They have a rainbow mane.")
            (p "And they dash through the sky!")))

        (define found-elements (before-the-fold my-article))
        (check-equal? (length found-elements) 3))

      (test-case
        "Get the first element if there is no fold"

        (define first-paragraph (p "There's no fold here?"))
        (define my-article
          (article "Hey" #f '()
            first-paragraph
            (p "Nope, I'm fine, thanks.")))
        (check-equal? (before-the-fold my-article)
                      (list first-paragraph)))
    )))
