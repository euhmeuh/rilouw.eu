#lang racket/base

(provide
  article-page)

(require
  racket/list
  "_base.rkt"
  "../entities/blog.rkt")

(define (article-page db article)
  (define back-home-link
    (paragraph (link "Back home" "/")))
  (define tags-list
    (apply paragraph (cons "Tags: "
                           (add-between (article-tags article) ", "))))
  (base-page db (article-title article) '()
    (lambda ()
      `(main
         (article
           (header
             (h2 ([id ,(article-id article)]) ,(article-title article))
             (small "Published " ,(render-element (article-date article))))
           ,@(render-elements article)
           ,(render-element tags-list)
           ,(render-element back-home-link))))))
