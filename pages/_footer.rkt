#lang racket/base

(provide
  render-footer)

(require
  racket/list
  racket/class
  "../entities/blog.rkt")

(define (render-frequent-tags tags)
  `(p ([class "center"]) ,@(add-between (map render-element tags) 'nbsp)))

(define (render-footer db)
  `(footer
     (hr ([class "fancy"]))
     (h2 ([id "topics"]) "Hot topics")
     ,(render-frequent-tags (send db get-frequent-tags #:at-least 1))
     (h2 ([id "about"]) "About this blog")
     (p "Hey! I'm Jérôme, feminist hacker.")
     (p "I learn new things everyday, and I like to put up great "
        "and sometimes useless theories about the inner workings of the world, which you'll find here.")
     (p "This blog is mostly about feminism, ecology and hacking. Please read and enjoy responsibly.")
     (hr)
     (p "Copyright © Jérôme Martin - All rights reserved.")
     (p ([class "small"])
        "Fira Code © Mozilla, used under the OFL license." (br)
        "Source Serif Pro © Adobe, used under the OFL license.")))
