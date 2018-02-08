#lang racket/base

(provide
  base-page
  page-description
  page-author
  page-keywords)

(require
  racket/string
  "_footer.rkt"
  "../entities/blog.rkt")

(define basic-links
  (list
    (link "Hot topics" "#topics")
    (link "About" "#about")))

(define page-description (make-parameter "Jérôme's blog about slow-tech, feminism & ecology."))
(define page-author (make-parameter "Jérôme Martin"))
(define page-keywords
  (make-parameter
    (string-join
      (list
        "slow tech"
        "feminism"
        "ecology"
        "jerome martin"
        "jérôme martin"
        "information technology"
        "IT"
        "technology"
        "lisp"
        "scheme"
        "racket"
        "programming"
        "programmer"
        "dev"
        "development")
      ", ")))

(define (render-navigation links)
  `(nav (ul ,@(map (lambda (link)
                     `(li ,(render-element link)))
                   links))))

(define (render-title title)
  `(title ,(string-append title " | Rilouw.eu")))

(define (base-page db title links renderer)
  `(html ([lang "en"])
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
       ,(render-navigation (cons (link "Home" "/")
                                 (append links basic-links)))
       ,(renderer)
       ,(render-footer db))))
