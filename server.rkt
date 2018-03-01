#lang web-server

(require
  racket/class
  web-server/servlet
  web-server/servlet-env
  web-server/managers/none
  web-server/configuration/responders
  "database/article-db.rkt"
  "site-mode.rkt")

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

(define (response-not-found req)
  (local-require "pages/404.rkt")
  (response/xexpr
    #:code 404
    #:message #"Not found"
    #:preamble #"<!DOCTYPE html>"
    (not-found-page article-db)))

(define (response-error url exception)
  (local-require "pages/500.rkt")
  (log-error "~s" `((exn ,(exn-message exception))
                    (uri ,(url->string url))
                    (time ,(current-seconds))))
  (response/xexpr
    #:code 500
    #:message #"Internal server error"
    #:preamble #"<!DOCTYPE html>"
    (error-page article-db)))

(define-values
  (blog-dispatcher blog-url)
  (dispatch-rules
    [("") response-index]
    [("article" (string-arg)) response-article]
    [("tag" (string-arg)) response-tag]))

(define (wrap-in-logger dispatcher)
  (local-require (only-in web-server/dispatchers/dispatch-log
                          extended-format))
  (lambda (req)
    (display (extended-format req))
    (dispatcher req)))

(define article-db (new article-db% [path article-root-path]))
(send article-db start)

(serve/servlet
  (wrap-in-logger blog-dispatcher)
  #:command-line? #t
  #:banner? #t
  #:servlet-regexp #rx""
  #:listen-ip (if-debug "127.0.0.1" #f)
  #:port (if-debug 8000 80)
  #:manager (create-none-manager response-not-found)
  #:servlet-responder (if-debug servlet-error-responder response-error)
  #:server-root-path (server-root-path)
  #:extra-files-paths (list static-root-path)
  #:file-not-found-responder response-not-found)
