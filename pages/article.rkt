#lang racket/base

(provide
  article-page)

(require
  racket/list
  (only-in web-galaxy/translate tr)
  rilouw-website/pages/base
  rilouw-website/entities/blog)

(define (article-page db article)
  (define back-home-link
    (div (link (tr back-home-link) "/")))
  (define tags-list
    (apply p (cons (tr tag-list)
                   (add-between (article-tags article) ", "))))
  (base-page db (article-title article) '()
    (lambda ()
      `(main
         (article
           (header
             (h2 ([id ,(article-id article)]) ,(article-title article))
             (small ,(tr published) ,(render-element (article-date article))))
           ,@(render-elements article)
           ,(render-element tags-list)
           ,(render-element back-home-link))))))
