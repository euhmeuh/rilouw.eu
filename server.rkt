#lang web-server

(require "pages/index.rkt")

(define (response-page req renderer)
  (response/xexpr
    #:preamble #"<!DOCTYPE html>"
    (renderer)))

(define (load-article path)
  (dynamic-require path 'article))

(define (response-index req)
  (define articles
    (list (load-article (build-path article-root "vegetables.rkt"))
          (load-article (build-path article-root "failure.rkt"))))
  (response-page req (lambda ()
                       (render-index articles))))

(define (response-not-found)
  (local-require "pages/404.rkt")
  (response/xexpr
    #:code 404
    #:message #"Not found"
    (render-404)))

(define (response-raw data mime-type)
  (response/output
    (lambda (client-out)
      (write-bytes data client-out))
    #:message #"OK"
    #:mime-type mime-type))

(define mime-types
  #hash((#""     . TEXT/HTML-MIME-TYPE)
        (#"html" . TEXT/HTML-MIME-TYPE)
        (#"css"  . #"text/css; charset=utf-8")
        (#"png"  . #"image/png")
        (#"rkt"  . #"text/x-racket; charset=utf-8")))

(define (extension->mime-type extension)
  (hash-ref mime-types extension
    (lambda () TEXT/HTML-MIME-TYPE)))

(define (handle-file-request req)
  (define uri (request-uri req))
  (define resource (map path/param-path (url-path uri)))
  (define file (apply build-path (cons static-root resource)))
  (if (file-exists? file)
    (let* ([extension (filename-extension file)]
           [mime-type (extension->mime-type extension)]
           [data (file->bytes file)])
      (response-raw data mime-type))
    (response-not-found)))

(define static-root
  (path->string
    (build-path (current-directory) "static")))

(define article-root
  (path->string
    (build-path (current-directory) "articles")))

(define-values
  (blog-dispatcher blog-url)
  (dispatch-rules
    [("") response-index]
    [else handle-file-request]))

(serve/dispatch blog-dispatcher)
