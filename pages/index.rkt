#lang racket/base

(provide render-index)

(require
  racket/list
  "_base.rkt"
  "../entities/blog.rkt")

(define links
  (list
    (link "Vegetables" "#vegetables")
    (link "Fruits" "#fruits")
    (link "About" "#about")))

(define articles
  (list
    (article "Vegetables"
      (paragraph "I love vegetables.")
      (paragraph "abcdefghijklmnopqrstuvwxyz")
      (paragraph "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefgh")
      (section "Especially"
        (paragraph "Bla bla bla...")
        (paragraph "Bla bla.")))
    (article "Fruits"
      (paragraph "I also like fruits.")
      (section "Especially"
        (paragraph
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
        (note "Note to self: add some content here."))
      (paragraph
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))))

(define (render-indent indent)
  (if (> indent 0)
      (format "indent-~a" indent)
      ""))

(define (render-paragraph paragraph)
  `(p ([class ,(render-indent (element-indent paragraph))])
      ,@(render-elements (container-elements paragraph))))

(define (render-section section)
  `(section (h3 ([class ,(render-indent (element-indent section))]
                 [id ,(section-id section)])
                ,(section-title section))
            ,@(render-elements (container-elements section))))

(define (render-note note)
  `(aside ,@(render-elements (container-elements note))))

(define (render-element element)
  (cond
    [(paragraph? element) (render-paragraph element)]
    [(section? element) (render-section element)]
    [(note? element) (render-note element)]
    [(link? element) (render-link element)]
    [else element]))

(define (render-elements elements)
  (map render-element elements))

(define (render-article article)
  `(article
     (h2 ([id ,(article-id article)]) ,(article-title article))
     ,@(render-elements (container-elements article))))

(define (render-articles articles)
  (define separator '(hr ([class "fancy"])))
  (add-between (map render-article articles) separator))

(define (render-index)
  (render-base "Hello Rilouw!" links
    (lambda ()
      `(main ,@(render-articles articles)))))
