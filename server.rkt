#lang web-server

(require
  racket/cmdline
  racket/class
  web-galaxy/translate
  web-galaxy/response
  web-galaxy/serve
  (only-in web-galaxy/renderer current-custom-renderers)
  (only-in "entities/blog.rkt" render-tag)
  "database/article-db.rkt")

(define static-root-path
  (path->string (build-path (current-server-root-path) "static")))

(define article-root-path
  (path->string (build-path (current-server-root-path) "articles")))

(current-language 'en)
(current-country 'fr)
(current-translations-dir "translations")
(load-translations!)

(define-response (index)
  (local-require "pages/index.rkt")
  (response-page (index-page article-db)))

(define-response (article article-id)
  (local-require "pages/article.rkt")
  (define article (send article-db find-article-by-id article-id))
  (if article
      (response-page (article-page article-db article))
      (response-not-found req)))

(define-response (tag a-tag)
  (local-require "pages/index.rkt")
  (define found-articles
    (send article-db find-articles-tagged (string->symbol a-tag)))
  (if found-articles
      (response-page (index-page article-db
                                 (tr articles-tagged-title a-tag)
                                 found-articles))
      (response-not-found req)))

(define-response (not-found)
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

(command-line
  #:once-each
  [("-p" "--port") port-arg
   "Open the server on a specific port"
   (let ([port (string->number port-arg)])
     (if (and port
              (exact-positive-integer? port)
              (port . <= . 65535))
        (current-server-port port)
        (raise-user-error 'wrong-port "Port should be an integer between 1 and 65535 (given: ~a)" port-arg)))]
  [("-a" "--address") address
   "Listen on a specific IP address"
   (current-server-listen-ip address)])

(define article-db (new article-db% [path article-root-path]))
(send article-db start)

(parameterize ([current-server-static-paths (list static-root-path)]
               [current-not-found-responder response-not-found]
               [current-error-responder response-error]
               [current-custom-renderers `([,symbol? . ,render-tag])])
  (serve/all
    [("") response-index]
    [("article" (string-arg)) response-article]
    [("tag" (string-arg)) response-tag]))
