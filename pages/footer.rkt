#lang racket/base

(provide
  render-footer)

(require
  racket/list
  racket/class
  (only-in web-galaxy/translate tr)
  rilouw-website/entities/blog)

(define (render-frequent-tags tags)
  `(div ([class "center"]) ,@(add-between (map render-element tags) " ")))

(define (render-footer db)
  `(footer
     (hr ([class "fancy"]))
     (h2 ([id "topics"]) ,(tr hot-topics-link))
     ,(render-frequent-tags (send db get-frequent-tags #:at-least 1))
     (h2 ([id "about"]) ,(tr about-title))
     (p ,(tr about-presentation-01))
     (p ,(tr about-presentation-02))
     (p ,(tr about-presentation-03))
     (p ,(tr about-mastodon)
        (a ([rel "me"] [href "https://mamot.fr/@euhmeuh"])
          "@euhmeuh@mamot.fr"))
     (p ,(tr about-contact))
     (ul
       (li "Pixelfed ─ " (a ([href "https://pixelfed.de/zoebourdon"]) "@zoebourdon@pixelfed.de"))
       (li "Mastodon ─ " (a ([href "https://mamot.fr/@euhmeuh"]) "@euhmeuh@mamot.fr"))
       (li "Sourcehut ─ " (a ([href "https://sr.ht/~euhmeuh"]) "~euhmeuh"))
       (li "Tumblr ─ " (a ([href "https://zoebourdon.fr"]) "zoebourdon.fr"))
       )
     (p ([class "small center"])
       (a ([href "https://webring.xxiivv.com/#ferale"] [target "_blank"])
        (img ([width "50px"]
              [height "50px"]
              [src "https://webring.xxiivv.com/icon.black.svg"]
              [alt "XXIIVV webring"])))
       (br)
       ,(tr footer-webring))
     (hr)
     (p ([class "small center"])
        ,(tr copyright) (br)
        ,(tr license-font-fira) (br)
        ,(tr license-font-source))
     (img ([class "decor"] [src "/witch.jpg"]))
     (p ([class "small center"])
       ,(tr footer-quote))
     ))
