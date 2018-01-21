#lang racket/base

(provide render-base)

(require "../entities/base.rkt")

(define (render-navigation links)
  (define (render-link link)
    `(li (a ([href ,(link-url link)]) ,(link-text link))))
  `(nav (ul ,@(map render-link links))))

(define (render-base page-title links render-page)
  `(html ([lang "en"])
     (head
       (meta ([charset "utf-8"]))
       (meta ([name "viewport"]
              [content "width=device-width, initial-scale=1.0, shrink-to-fit=no"]))
       (title ,page-title)
       (link ([rel "stylesheet"] [type "text/css"] [href "/common.css"])))
     (body
       (header (h1 "Rilouw.eu"))
       ,(render-navigation links)
       ,(render-page)
       (footer
         (hr ([class "fancy"]))
         (h2 ([id "about"]) "About us")
         (p "We like vegetables and fruits")
         (hr)
         (p "Copyright © euhmeuh - All rights reserved.")))))
