#lang racket/base

(require
  racket/string
  racket/list
  web-server/servlet
  web-server/servlet-env)

(struct link (text url))

(struct article (id title body))

(define (make-article title . body)
  (article (normalize title) title body))

(define (normalize str)
  (string-downcase
    (string-normalize-spaces str #rx"[^a-zA-Z0-9]+" "-")))

(define links
  (list
    (link "Vegetables" "#vegetables")
    (link "Fruits" "#fruits")
    (link "About" "#about")))

(define articles
  (list (make-article "Vegetables"
          '(p "I love vegetables.")
          '(p "abcdefghijklmnopqrstuvwxyz")
          '(p "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefgh")
          '(h3 "Especially")
          '(p "Bla bla bla...")
          '(p "Bla bla."))
    (make-article "Fruits"
      '(p "I also like fruits.")
      '(h3 "Especially")
      '(p "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
      '(aside (p "Note to self: add some content here."))
      '(p "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
          "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))))

(define (render-navigation links)
  (define (render-link link)
    `(li (a ([href ,(link-url link)]) ,(link-text link))))
  `(nav (ul ,@(map render-link links))))

(define (render-articles articles)
  (define (render-article article)
    `(article
      (h2 ([id ,(article-id article)]) ,(article-title article))
      ,@(article-body article)))
  (define separator '(hr ([class "fancy"])))
  (add-between (map render-article articles) separator))

(define (start req)
  (response/xexpr
   `(html
      ([lang "en"])
      (meta ([charset "utf-8"]))
      (meta ([name "viewport"]
             [content "width=device-width, initial-scale=1.0, shrink-to-fit=no"]))
      (head (title "Hello world!")
            (style ([type "text/css"])
                   "@keyframes focus {0% {outline: 1px solid; outline-offset: 1em;} 100% {outline: 6px solid; outline-offset: .10em;}}"
                   "a:focus {outline: 6px solid; outline-offset: .10em; animation: focus .15s}"
                   "html {font-family: Fira Code;}"
                   "body {min-width: 26ch; max-width: 60ch; width: 100%; margin: 0 auto;}"
                   "aside {width: 50%; float: right;}"
                   "aside p {margin: 10px; text-align: right;}"
                   "p {text-align: justify;}"
                   "hr.fancy {padding: 0; margin: 1.5em 0 -1.5em 0; border: none; border-top: medium double #333; color: #333; text-align: center;}"
                   "hr.fancy:after {content: '\u2766'; display: inline-block; position: relative; top: -0.7em; font-size: 1.5em; padding: 0 0.25em; background: white;}"
                   "article h2::before, article h3::before, article p::before, article p::after {color: #CCC; font-size: 1rem; font-weight: normal;}"
                   "article h2::before {content: '(article ';}"
                   "article h3::before {content: '(section ';}"
                   "article p::before {content: '(\u00A7 ';}"
                   "article p::after {content: ')'}"
                   "article p:last-of-type::after {content: '))';}"
                   ".indent-1 {text-indent: -2ch; margin-left: 4ch;}"
                   ".indent-2 {text-indent: -2ch; margin-left: 6ch;}"
                   ".indent-3 {text-indent: -2ch; margin-left: 8ch;}"
                   ))
      (body (header (h1 "Vegetables & Fruits"))
            ,(render-navigation links)
            (main ,@(render-articles articles))
            (footer
              (hr ([class "fancy"]))
              (h2 ([id "about"]) "About us")
              (p "We like vegetables and fruits")
              (hr)
              (p "Copyright Blabla, Inc. All rights reserved."))))))
 
(serve/servlet start)
