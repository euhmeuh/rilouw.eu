#lang racket/base

(provide
  index-page)

(require
  racket/list
  racket/class
  "_base.rkt"
  "../entities/blog.rkt"
  "../entities/urls.rkt")

(define (render-article-preview article)
  (define full-article-link
    (paragraph (link "Full article..." (make-article-url (article-id article)))))
  `(article
     (h2 ([id ,(article-id article)]) ,(article-title article))
     ,(render-element (first (container-elements article)))
     ,(render-element full-article-link)))

(define separator '(hr ([class "fancy"])))

(define (render-articles articles)
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (article-title article)
        (format "#~a" (article-id article))))

(define (index-page db [title "Home"] [articles #f])
  (when (not articles)
    (set! articles (send db get-recent-articles)))
  (base-page db title (map article->link articles)
    (lambda ()
      `(main
         (h2 ,title)
         ,separator
         ,@(render-articles articles)))))
