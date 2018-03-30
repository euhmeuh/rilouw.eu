#lang racket/base

(provide
  render-footer)

(require
  racket/list
  racket/class
  "../entities/blog.rkt"
  (only-in "../l10n/translate.rkt" tr))

(define (render-frequent-tags tags)
  `(p ([class "center"]) ,@(add-between (map render-element tags) 'nbsp)))

(define (render-footer db)
  `(footer
     (hr ([class "fancy"]))
     (h2 ([id "topics"]) ,(tr hot-topics-link))
     ,(render-frequent-tags (send db get-frequent-tags #:at-least 1))
     (h2 ([id "about"]) ,(tr about-title))
     (p ,(tr about-presentation-01))
     (p ,(tr about-presentation-02))
     (p ,(tr about-presentation-03))
     (hr)
     (p ,(tr copyright))
     (p ([class "small"])
        ,(tr license-font-fira) (br)
        ,(tr license-font-source))))
