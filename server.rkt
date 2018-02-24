#lang web-server

(require
  racket/class
  web-server/servlet
  web-server/servlet-env
  web-server/page
  "database/article-db.rkt"
  "pages/editor.rkt")

(define-syntax-rule (if-debug then else)
  (if (getenv "DEBUG") then else))

(define-syntax-rule (response-page content)
  (response/xexpr
    #:preamble #"<!DOCTYPE html>"
    content))

(define server-root-path (make-parameter (current-directory)))

(define static-root-path
  (path->string
    (build-path (server-root-path) "static")))

(define article-root-path
  (path->string
    (build-path (server-root-path) "articles")))

(define (response-index req)
  (local-require "pages/index.rkt")
  (response-page (index-page article-db)))

(define (response-article req article-id)
  (local-require "pages/article.rkt")
  (define article (send article-db find-article-by-id article-id))
  (if article
      (response-page (article-page article-db article))
      (response-not-found req)))

(define (response-tag req tag)
  (local-require "pages/index.rkt")
  (define found-articles
    (send article-db find-articles-tagged (string->symbol tag)))
  (if found-articles
      (response-page (index-page article-db
                                 (format "Articles tagged '~a'" tag)
                                 found-articles))
      (response-not-found req)))

(define/page (response-editor [article #f])
  (local-require "pages/editor.rkt")
  (response-page (editor-page response-editor embed/url article)))

(define (response-not-found req)
  (local-require "pages/404.rkt")
  (response/xexpr
    #:code 404
    #:message #"Not found"
    #:preamble #"<!DOCTYPE html>"
    (not-found-page article-db)))

(define-values
  (blog-dispatcher blog-url)
  (dispatch-rules
    [("") response-index]
    [("article" (string-arg)) response-article]
    [("tag" (string-arg)) response-tag]
    [("editor") response-editor]))

(define article-db (new article-db% [path article-root-path]))
(send article-db start)

(serve/servlet
  blog-dispatcher
  #:command-line? #t
  #:servlet-regexp #rx""
  #:listen-ip (if-debug "127.0.0.1" #f)
  #:port 8000
  #:server-root-path (server-root-path)
  #:extra-files-paths (list static-root-path)
  #:file-not-found-responder response-not-found
  #:log-file "logs.txt")
