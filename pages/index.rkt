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
  (list (load-article "articles/vegetables.rkt")
        (load-article "articles/failure.rkt")))

(define (render-paragraph paragraph)
  `(p ([class "indent"])
      ,@(render-elements (container-elements paragraph))))

(define (render-section section)
  `(section ([class "indent"])
            (h3 ([id ,(section-id section)])
                ,(section-title section))
            ,@(render-elements (container-elements section))))

(define (render-note note)
  `(aside ,@(render-elements (container-elements note))))

(define (render-dotted-list dotted-list)
  `(ul ([class "indent"])
       ,@(map (lambda (element)
                `(li ,(render-element element)))
              (container-elements dotted-list))))

(define (render-element element)
  (cond
    [(paragraph? element) (render-paragraph element)]
    [(section? element) (render-section element)]
    [(note? element) (render-note element)]
    [(dotted-list? element) (render-dotted-list element)]
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
