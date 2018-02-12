#lang racket/base

(provide
  gen:renderer
  define-renderer
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

(require
  (for-syntax racket/base)
  (for-syntax racket/syntax))

(define-generics renderer
  (render renderer))

#|
(define-renderer link (text url)
  `(a ([href ,(link-url link)]) ,(link-text link)))

;; should expand to:

(struct link (text url)
  #:methods gen:renderer
  [(define (render link)
    ((render-link) link))])

(define render-link
  (make-parameter
    (lambda (link)
      `(a ([href ,(link-url link)]) ,(link-text link)))))
|#
(define-syntax (define-renderer stx)
  (define (make-struct-elements stx name body)
    (syntax->list
      #`(#:methods gen:renderer
         [(define (render #,name) #,body)])))

  (define (make-render-function stx name fields body)
    (with-syntax ([function-name (format-id stx "render-~a" name)])
      #`(define function-name
          (make-parameter (lambda (#,name) #,body)))))

  (syntax-case stx ()
    [(_ name (field ...) body)
     (with-syntax ([(struct-el ...) (make-struct-elements stx #'name #'body)]
                   [render-function (make-render-function stx #'name #'(field ...) #'body)])
       #'(begin
           (struct name (field ...) struct-el ...)
           render-function))]

    [(_ name parent (field ...) body)
     (with-syntax ([(struct-el ...) (make-struct-elements stx #'name #'body)]
                   [render-function (make-render-function stx #'name #'(field ...) #'body)])
       #'(begin
           (struct name parent (field ...) struct-el ...)
           render-function))]))

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
  `(a ([href ,(link-url link)]) ,(link-text link)))

(define render-tag
  (make-parameter
    (lambda (symbol)
      (render-element (link (symbol->string symbol)
                            (make-tag-url symbol))))))

(define (newline)
  '(br))
