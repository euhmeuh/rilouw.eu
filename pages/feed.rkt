#lang racket/base

(provide
  feed-page)

(require
  (only-in xml xexpr->string)
  rilouw-website/entities/blog
  rilouw-website/entities/urls)

(define (render-full-tag symbol)
  (render-element (link (make-tag-url symbol #:full #t)
                        (symbol->string symbol))))

(define (render-article article)
  (define full-article-link (make-article-url (article-id article) #:full #t))
  `(entry
    (title ,(article-title article))
    (link ([href ,full-article-link] [rel "alternate"]))
    (id ,full-article-link)
    (published ,(format-pubdate (article-date article) 'iso))
    (updated ,(format-pubdate (article-date article) 'iso))
    ,(parameterize ([current-custom-renderers `([,symbol? . ,render-full-tag])])
      `(summary ([type "html"])
        ,(xexpr->string
           `(div
              ,@(map render-element (before-the-fold article))
              (a ([href ,full-article-link]) "Read complete article")))))
  ))

(define (feed-page db articles)
  `(feed ([xmlns "http://www.w3.org/2005/Atom"])
     (title "Ferale.art")
     (subtitle "Zoé's blog about slow-tech, feminism & ecology.")
     (author (name "Zoé Martin") (uri "https://mamot.fr/@euhmeuh"))
     (rights "Copyright © Zoé Martin")
     (link ([href "https://ferale.art/feed"] [rel "self"]))
     (link ([href "https://ferale.art"]))
     (id "https://ferale.art")
     (updated "2022-02-08T19:46:00+01:00")
     
     ,@(map render-article articles)
   ))
