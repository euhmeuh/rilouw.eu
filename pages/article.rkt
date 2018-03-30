#lang racket/base

(provide
  article-page)

(require
  racket/list
  "_base.rkt"
  "../entities/blog.rkt"
  (only-in "../l10n/translate.rkt" tr))

(define (article-page db article)
  (define back-home-link
    (paragraph (link (tr back-home-link) "/")))
  (define tags-list
    (apply paragraph (cons (tr tag-list)
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
