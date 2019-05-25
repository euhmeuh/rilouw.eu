#lang racket/base

(provide
  base-page
  page-description
  page-author
  page-keywords)

(require
  racket/string
  (only-in web-galaxy/translate
           tr
           current-language)
  rilouw-website/entities/blog
  rilouw-website/pages/footer)

(define (menu-links)
  (list
    (link "/" (tr home-link))
    (link "/projects" (tr projects-link))
    (link "/talks" (tr talks-link))
    (link "#topics" (tr hot-topics-link))
    (link "#about" (tr about-link))))

(define (page-description) (tr page-description))
(define page-author (make-parameter "Jérôme Martin"))
(define page-keywords
  (make-parameter
    (string-join
      (list
        "feminism"
        "ecology"
        "hacking"
        "slow tech"
        "jerome martin"
        "jérôme martin"
        "information technology"
        "technology"
        "lisp"
        "scheme"
        "racket"
        "programming"
        "development"
        "blog")
      ", ")))

(define (render-navigation . links-lists)
  `(nav ,@(map (lambda (links)
                 `(ul ,@(map (lambda (link)
                               `(li ([class "big"])
                                    ,(render-element link)))
                             links)))
               links-lists)))

(define (render-title title)
  `(title ,(string-append title " | Rilouw.eu")))

(define (base-page db title links renderer)
  `(html ([lang ,(symbol->string (current-language))])
     (head
       (meta ([charset "utf-8"]))
       (meta ([name "viewport"]
              [content "width=device-width, initial-scale=1.0, shrink-to-fit=no"]))
       (meta ([name "description"] [content ,(page-description)]))
       (meta ([name "keywords"] [content ,(page-keywords)]))
       (meta ([name "author"] [content ,(page-author)]))
       (link ([rel "icon"] [href "/favicon.ico"]))
       (link ([rel "shortcut icon"] [href "/favicon.ico"]))
       (link ([rel "stylesheet"] [type "text/css"] [href "/common.css"]))
       ,(render-title title))
     (body
       (header ([class "flex"])
         (h1 ([class "flex-1"]) ,(tr main-title))
         (aside ([class "flex-1"]) ,(tr main-subtitle)))
       ,(render-navigation (menu-links) links)
       (hr ([class "fancy"]))
       ,(renderer)
       ,(render-footer db))))
