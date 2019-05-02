#lang racket/base

(require
  racket/cmdline
  racket/class
  net/url
  web-galaxy/translate
  web-galaxy/response
  web-galaxy/serve
  (only-in web-galaxy/renderer current-custom-renderers)
  rilouw-website/database/article-db
  (only-in rilouw-website/entities/blog render-tag))

(define static-root-path
  (path->string (build-path (current-server-root-path) "static")))

(define article-root-path
  (path->string (build-path (current-server-root-path) "articles")))

(current-language 'en)
(current-country 'fr)
(current-translations-dir "translations")
(load-translations!)

(define-response (index)
  (local-require rilouw-website/pages/index)
  (response/page (index-page article-db)))

(define-response (article article-id)
  (local-require rilouw-website/pages/article)
  (define article (send article-db find-article-by-id article-id))
  (if article
      (response/page (article-page article-db article))
      (response-not-found req)))

(define-response (tag a-tag)
  (local-require rilouw-website/pages/index)
  (define found-articles
    (send article-db find-articles-tagged a-tag))
  (if found-articles
      (response/page (index-page article-db
                                 (tr articles-tagged-title a-tag)
                                 found-articles))
      (response-not-found req)))

(define-response (not-found)
  (local-require rilouw-website/pages/404)
  (response/xexpr
    #:code 404
    #:message #"Not found"
    #:preamble #"<!DOCTYPE html>"
    (not-found-page article-db)))

(define (response-error url exception)
  (local-require rilouw-website/pages/500)
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
    [GET ("") response-index]
    [GET ("article" (symbol-arg)) response-article]
    [GET ("tag" (symbol-arg)) response-tag]))
