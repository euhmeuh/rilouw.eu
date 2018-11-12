#lang racket/base

(provide
  index-page)

(require
  racket/list
  racket/class
  (only-in web-galaxy/translate tr)
  rilouw-website/pages/base
  rilouw-website/entities/blog
  rilouw-website/entities/urls)

(define (render-important-link link)
  `(a ([href ,(link-url link)]
       [class "important-link"])
      ,(link-text link)))

(define (render-article-preview article)
  (define full-article-link
    (div (link (tr read-the-article) (make-article-url (article-id article)))))
  `(article
     (header
       (h2 ([id ,(article-id article)]) ,(article-title article))
       (small ,(tr published) ,(render-element (article-date article))))
     ,@(map render-element (before-the-fold article))
     ,(parameterize ([render-link render-important-link])
        (render-element full-article-link))))

(define separator '(hr ([class "fancy"])))

(define (render-articles articles)
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (format "~a ~a"
                (format-pubdate (article-date article) 'iso)
                (article-title article))
        (format "#~a" (article-id article))))

(define (index-page db [title #f] [articles #f])
  (set! title (or title (tr home-title)))
  (when (not articles)
    (set! articles (send db get-recent-articles)))
  (base-page db title (map article->link articles)
    (lambda ()
      `(main
         (h2 ,title)
         ,separator
         ,@(render-articles articles)))))
