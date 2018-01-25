#lang racket/base

(provide render-index)

(require
  racket/list
  "_base.rkt"
  "../entities/blog.rkt")

(define (make-article-url article-id)
  (format "/article/~a" article-id))

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

(define (render-article-preview article)
  (define full-article-link
    (paragraph (link "Full article..." (make-article-url (article-id article)))))
  `(article
     (h2 ([id ,(article-id article)]) ,(article-title article))
     ,(render-element (first (container-elements article)))
     ,(render-paragraph full-article-link)))

(define (render-articles articles)
  (define separator '(hr ([class "fancy"])))
  (add-between (map render-article-preview articles) separator))

(define (article->link article)
  (link (article-title article)
        (format "#~a" (article-id article))))

(define (render-index articles)
  (define article-links (map article->link articles))
  (define links (append article-links (list (link "About" "#about"))))
  (render-base "Hello Rilouw!" links
    (lambda ()
      `(main ,@(render-articles articles)))))
