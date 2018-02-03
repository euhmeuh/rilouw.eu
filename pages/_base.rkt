#lang racket/base

(provide
  render-base)

(require
  "_blog.rkt"
  "_footer.rkt"
  "../entities/base.rkt")

(define basic-links
  (list
    (link "Hot topics" "#topics")
    (link "About" "#about")))

(define (render-navigation links)
  `(nav (ul ,@(map (lambda (link)
                     `(li ,(render-link link)))
                   links))))

(define (render-title title)
  `(title ,(string-append title " | Rilouw.eu")))

(define (render-base page-title links tags render-page)
  `(html ([lang "en"])
     (head
       (meta ([charset "utf-8"]))
       (meta ([name "viewport"]
              [content "width=device-width, initial-scale=1.0, shrink-to-fit=no"]))
       ,(render-title page-title)
       (link ([rel "stylesheet"] [type "text/css"] [href "/common.css"])))
     (body
       (header (h1 "Rilouw.eu"))
       ,(render-navigation (cons (link "Home" "/")
                                 (append links basic-links)))
       ,(render-page)
       ,(render-footer tags))))
