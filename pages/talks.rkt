#lang racket/base

(provide
  talks-page)

(require
  (only-in web-galaxy/translate tr)
  rilouw-website/pages/base
  rilouw-website/entities/blog)

(define (render-talk-links links)
  `(ul ,@(map (lambda (link)
                `(li ([class "big"])
                     (a ([href ,link]) ,link)))
              links)))

(define (render-talk talk)
  `(section ([class "block"])
     (header ([class "flex"])
       (h3 ([id ,(symbol->string (talk-id talk))]
            [class "flex-1"])
          ,(talk-name talk))
       (aside ([class "flex-1"])
         ,(tr talk-event) ,(event-name (talk-event talk))))
     (p ,(talk-desc talk))
     ,(render-talk-links (talk-links talk))))

(define (talks-page db talks)
  (base-page db (tr talks-title) '()
    (lambda ()
      `(main
         (h2 ,(tr talks-title))
         ,@(map render-talk talks)))))
