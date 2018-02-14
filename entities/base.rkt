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
  (for-syntax racket/base
              racket/syntax
              syntax/stx)
  racket/generic
  "urls.rkt")

(define-generics renderer
  (render renderer))

#|
(define-renderer link (text url)
  `(a ([href ,(link-url link)]) ,(link-text link)))

;; will expand to:

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
  (define (make-struct-elements stx name function-name)
    (syntax->list
      (quasisyntax/loc stx
        (#:methods gen:renderer
         [(define (render #,name)
            ((#,function-name) #,name))]))))

  (define (make-render-function stx name function-name body)
    (quasisyntax/loc stx
      (define #,function-name
        (make-parameter (lambda (#,name) #,body)))))

  (define (make-struct-and-renderer stx name-maybe-parent fields body)
    (let* ([name (stx-car name-maybe-parent)]
           [function-name (format-id stx "render-~a" name)])
      (with-syntax ([(struct-el ...)
                     (make-struct-elements stx name function-name)]
                    [render-function
                     (make-render-function stx name function-name body)])
        #`(begin
            (struct #,@name-maybe-parent #,fields struct-el ...)
            render-function))))

  (syntax-case stx ()
    [(_ name (field ...) body)
     (make-struct-and-renderer stx #'(name) #'(field ...) #'body)]
    [(_ name parent (field ...) body)
     (make-struct-and-renderer stx #'(name parent) #'(field ...) #'body)]))

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
