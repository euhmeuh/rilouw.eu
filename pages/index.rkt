#lang racket/base

(provide
  index-page
  tag-page)

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
    (div (link (make-article-url (article-id article)) (tr read-the-article))))
  `(article
     (header
       (h2 ([id ,(symbol->string (article-id article))]) ,(article-title article))
       (small ,(tr published) ,(render-element (article-date article))))
     ,@(map render-element (before-the-fold article))
     ,(parameterize ([render-link render-important-link])
        (render-element full-article-link))))

(define separator '(hr ([class "fancy"])))

(define (render-articles articles)
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (format "#~a" (article-id article))
        (format "~a ~a"
                (format-pubdate (article-date article) 'iso)
                (article-title article))))

(define (index-page db articles)
  (base-page db (tr main-subtitle) (map article->link articles)
    (lambda ()
      `(main
         (h2 ,(tr home-title))
         ,@(render-articles articles)))))

(define (tag-page db tag articles)
  (define title (tr articles-tagged-title tag))
  (base-page db title (map article->link articles)
    (lambda ()
      `(main
         (h2 ,title)
         ,@(render-articles articles)))))
