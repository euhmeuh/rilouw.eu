#lang racket/base

(provide
  render-paragraph
  render-section
  render-note
  render-dotted-list
  render-elements
  render-element
  render-tag
  render-link
  ;; you can customize this parameter to change renderers for specific element types
  custom-renderer)

(require
  anaphoric
  "../entities/blog.rkt")

(define custom-renderer
  (make-parameter
    (lambda (element) #f)))

(define (render-element element)
  (aif ((custom-renderer) element)
       (it element)
       (cond
         [(paragraph? element) (render-paragraph element)]
         [(section? element) (render-section element)]
         [(note? element) (render-note element)]
         [(dotted-list? element) (render-dotted-list element)]
         [(link? element) (render-link element)]
         [(symbol? element) (render-tag element)]
         [else element])))

(define (render-elements container)
  (map render-element (container-elements container)))

(define (render-tag symbol)
  (render-link (link (symbol->string symbol)
                     (make-tag-url symbol))))

(define (render-paragraph paragraph)
  `(p ([class "indent"])
      ,@(render-elements paragraph)))

(define (render-section section)
  `(section ([class "indent"])
            (h3 ([id ,(section-id section)])
                ,(section-title section))
            ,@(render-elements section)))

(define (render-note note)
  `(aside ,@(render-elements note)))

(define (render-link link)
  `(a ([href ,(link-url link)]) ,(link-text link)))

(define (render-dotted-list dotted-list)
  `(ul ([class "indent"])
       ,@(map (lambda (element)
                `(li ,(render-element element)))
              (container-elements dotted-list))))
