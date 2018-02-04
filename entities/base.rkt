#lang racket/base

(provide
  gen:renderer
  render-element
  (struct-out container)
  render-elements
  (struct-out link)
  render-link
  render-tag
  newline)

(require
  racket/generic
  "urls.rkt")

(define-generics renderer
  (render renderer))

(define (render-element element)
  (cond
    [(renderer? element) (render element)]
    [(symbol? element)
      ((render-tag) element)]
    [else element]))

(struct container (elements))

(define (render-elements container)
  (map render-element (container-elements container)))

(struct link (text url)
  #:methods gen:renderer
  [(define (render link)
     ((render-link) link))])

(define render-link
  (make-parameter
    (lambda (link)
      `(a ([href ,(link-url link)]) ,(link-text link)))))

(define render-tag
  (make-parameter
    (lambda (symbol)
      (render-element (link (symbol->string symbol)
                            (make-tag-url symbol))))))

(define (newline)
  '(br))
