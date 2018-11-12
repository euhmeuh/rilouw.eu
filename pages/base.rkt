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

(define (basic-links)
  (list
    (link (tr hot-topics-link) "#topics")
    (link (tr about-link) "#about")))

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

(define (render-navigation links)
  `(nav (ul ,@(map (lambda (link)
                     `(li ,(render-element link)))
                   links))))

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
       (header (h1 "Rilouw.eu"))
       ,(render-navigation (cons (link (tr home-link) "/")
                                 (append links (basic-links))))
       ,(renderer)
       ,(render-footer db))))