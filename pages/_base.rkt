#lang racket/base

(provide
  base-page)

(require
  "_footer.rkt"
  "../entities/blog.rkt")

(define basic-links
  (list
    (link "Hot topics" "#topics")
    (link "About" "#about")))

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
       ,(render-title title)
       (link ([rel "stylesheet"] [type "text/css"] [href "/common.css"])))
     (body
       (header (h1 "Rilouw.eu"))
       ,(render-navigation (cons (link "Home" "/")
                                 (append links basic-links)))
       ,(renderer)
       ,(render-footer db))))
