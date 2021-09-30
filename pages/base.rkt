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

(define (menu-links)
  (list
    (link "/" (tr home-link))
    (link "/projects" (tr projects-link))
    (link "/talks" (tr talks-link))
    (link "#topics" (tr hot-topics-link))
    (link "#about" (tr about-link))))

(define (page-description) (tr page-description))
(define page-author (make-parameter "Zoé Martin"))
(define page-keywords
  (make-parameter
    (string-join
      (list
        "feminism"
        "ecology"
        "hacking"
        "slow tech"
        "zoe martin"
        "zoé martin"
        "information technology"
        "technology"
        "lisp"
        "scheme"
        "racket"
        "programming"
        "development"
        "blog")
      ", ")))

(define (render-navigation . links-lists)
  `(nav ,@(map (lambda (links)
                 `(ul ,@(map (lambda (link)
                               `(li ([class "big"])
                                    ,(render-element link)))
                             links)))
               links-lists)))

(define (render-title title)
  `(title ,(string-append title " | Rilouw.eu")))

(define (render-svg-filters)
  '(
    (svg ([xmlns "http://www.w3.org/2000/svg"] [class "hidden"])
      (filter ([id "jitter-filter"])
        (feTurbulence ([baseFrequency "0.01 0.02"] [numOctaves "2"] [result "t0"]))
        (feDisplacementMap ([in "SourceGraphic"] [in2 "t0"] [scale "4"] [result "d0"]))
        (feComposite ([in "SourceGraphic"] [in2 "d0"] [operator "atop"] [result "0"]))
        (feTurbulence ([baseFrequency "1"] [numOctaves "2"] [result "t1"]))
        (feDisplacementMap ([in "0"] [in2 "t1"] [scale "1"] [result "d1"]))
        (feComposite ([in "0"] [in2 "d1"] [operator "atop"] [result "1"]))
        (feOffset ([in "1"] [dx "-3"] [dy "-3"]))))
   ))

(define (base-page db title links renderer)
  `(html ([lang ,(symbol->string (current-language))])
     (head
       (meta ([charset "utf-8"]))
       (meta ([name "viewport"]
              [content "width=device-width, initial-scale=1.0, shrink-to-fit=no"]))
       (meta ([name "description"] [content ,(page-description)]))
       (meta ([name "keywords"] [content ,(page-keywords)]))
       (meta ([name "author"] [content ,(page-author)]))
       (meta ([property "og:image"] [content "/icon.png"]))
       (meta ([property "twitter:image"] [content "/icon.png"]))
       (link ([rel "icon"] [href "/favicon.ico"]))
       (link ([rel "shortcut icon"] [href "/favicon.ico"]))
       (link ([rel "stylesheet"] [type "text/css"] [href "/common.css"]))
       ,(render-title title))
     (body
       ,@(render-svg-filters)
       (header ([class "flex"])
         (h1 ([class "flex-1"]) ,(tr main-title))
         (aside ([class "flex-1"]) ,(tr main-subtitle)))
       ,(render-navigation (menu-links) links)
       (hr ([class "fancy"]))
       ,(renderer)
       ,(render-footer db))))
