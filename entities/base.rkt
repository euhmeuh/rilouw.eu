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

(define-syntax (define-renderer stx)
  (define (make-body stx name body)
    (syntax->list stx
      #'(#:methods gen:renderer
         [(define (render 'name) body)])))
  (syntax-case stx
    [(_ name field ... body)
     (with-syntax ([(body-el ...) (make-body stx #'name #'body)])
       (struct name (field ...) body-el ...))]
    [(_ name parent field ... body)
     (with-syntax ([(body-el ...) (make-body stx #'name #'body)])
       (struct name parent (field ...) body-el ...))]))


#'(begin
    (struct name parent? (fields ...)
      #:methods gen:renderer
      [(define (render name)
        ((render-name) name))])
    (define render-name
      (make-parameter
        (lambda (name)
          (let (name-field... name)
            body)))))


(define (render-element element)
  (cond
    [(renderer? element) (render element)]
    [(symbol? element)
      ((render-tag) element)]
    [else element]))

(struct container (elements))

(define (render-elements container)
  (map render-element (container-elements container)))

(define-renderer link (text url)
  `(a ([href ,url]) ,text))
#| should expand to:

(struct link (text url)
  #:methods gen:renderer
  [(define (render link)
    ((render-link) link))])

(define render-link
  (make-parameter
    (lambda (link)
      `(a ([href ,(link-url link)]) ,(link-text link)))))
|#

(define render-tag
  (make-parameter
    (lambda (symbol)
      (render-element (link (symbol->string symbol)
                            (make-tag-url symbol))))))

(define (newline)
  '(br))
