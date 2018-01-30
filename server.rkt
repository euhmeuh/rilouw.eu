#lang web-server

(require
  web-server/servlet
  web-server/servlet-env)

(define-syntax-rule (if-debug then else)
  (if (getenv "DEBUG") then else))

(define-syntax-rule (response-page content)
  (response/xexpr
    #:preamble #"<!DOCTYPE html>"
    content))

(define server-root-path (make-parameter (if-debug (current-directory) "/www")))

(define static-root-path
  (path->string
    (build-path (server-root-path) "static")))

(define article-root-path
  (path->string
    (build-path (server-root-path) "articles")))

(define (load-article path)
  (dynamic-require path 'article))

(define (find-article-by-id id)
  (local-require "entities/blog.rkt")
  (findf
    (lambda (article)
      (string-ci=? (article-id article) id))
    *articles*))

(define (get-articles)
  (local-require "entities/blog.rkt")
  (filter
    (not/c draft?)
    (for/list ([article-path (in-directory article-root-path
                                           (lambda (path)
                                             (regexp-match? #rx"\\.rkt$" path)))])
      (load-article article-path))))

(define *articles* (get-articles))

(define (response-index req)
  (local-require "pages/index.rkt")
  (response-page (render-index *articles*)))

(define (response-article req article-id)
  (local-require "pages/article.rkt")
  (define article (find-article-by-id article-id))
  (if article
      (response-page (render-article article))
      (response-not-found req)))

(define (response-not-found req)
  (local-require "pages/404.rkt")
  (response/xexpr
    #:code 404
    #:message #"Not found"
    #:preamble #"<!DOCTYPE html>"
    (render-404)))

(define-values
  (blog-dispatcher blog-url)
  (dispatch-rules
    [("") response-index]
    [("article" (string-arg)) response-article]))

(serve/servlet
  blog-dispatcher
  #:command-line? #t
  #:servlet-regexp #rx""
  #:listen-ip (if-debug "127.0.0.1" #f)
  #:server-root-path (server-root-path)
  #:extra-files-paths (list static-root-path)
  #:file-not-found-responder response-not-found)
