#lang web-server

(require
  web-server/servlet
  web-server/servlet-env)

(define-syntax-rule (if-debug then else)
  (if (getenv "DEBUG") then else))

(define (response-page req renderer)
  (response/xexpr
    #:preamble #"<!DOCTYPE html>"
    (renderer)))

(define (load-article path)
  (dynamic-require path 'article))

(define (response-index req)
  (local-require "pages/index.rkt")
  (define articles
    (list (load-article (build-path article-root-path "vegetables.rkt"))
          (load-article (build-path article-root-path "failure.rkt"))))
  (response-page req (lambda ()
                       (render-index articles))))

(define (response-not-found req)
  (local-require "pages/404.rkt")
  (response/xexpr
    #:code 404
    #:message #"Not found"
    (render-404)))

(define server-root-path (make-parameter (if-debug (current-directory) "/www")))

(define static-root-path
  (path->string
    (build-path (server-root-path) "static")))

(define article-root-path
  (path->string
    (build-path (server-root-path) "articles")))

(define-values
  (blog-dispatcher blog-url)
  (dispatch-rules
    [("") response-index]))

(serve/servlet
  blog-dispatcher
  #:command-line? #t
  #:servlet-regexp #rx""
  #:listen-ip (if-debug "127.0.0.1" #f)
  #:server-root-path (server-root-path)
  #:extra-files-paths (list static-root-path)
  #:file-not-found-responder response-not-found)
