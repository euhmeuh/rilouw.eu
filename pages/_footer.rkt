#lang racket/base

(provide
  render-footer)

(require
  racket/list
  racket/class
  "../entities/blog.rkt"
  (only-in "../l10n/locale.rkt" loc))

(define (render-frequent-tags tags)
  `(p ([class "center"]) ,@(add-between (map render-element tags) 'nbsp)))

(define (render-footer db)
  `(footer
     (hr ([class "fancy"]))
     (h2 ([id "topics"]) ,(loc hot-topics-link))
     ,(render-frequent-tags (send db get-frequent-tags #:at-least 1))
     (h2 ([id "about"]) ,(loc about-title))
     (p ,(loc about-presentation-01))
     (p ,(loc about-presentation-02))
     (p ,(loc about-presentation-03))
     (hr)
     (p ,(loc copyright))
     (p ([class "small"])
        ,(loc license-font-fira) (br)
        ,(loc license-font-source))))
