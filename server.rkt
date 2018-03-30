#lang web-server

(require
  racket/cmdline
  racket/class
  web-server/servlet
  web-server/servlet-env
  web-server/managers/none
  web-server/configuration/responders
  "database/article-db.rkt"
  "l10n/translate.rkt"
  "response.rkt"
  "site-mode.rkt")

(define server-root-path (make-parameter (current-directory)))
(define server-port (make-parameter (if-debug 8000 80)))
(define server-listen-ip (make-parameter (if-debug "127.0.0.1" #f)))

(define static-root-path
  (path->string (build-path (server-root-path) "static")))

(define article-root-path
  (path->string (build-path (server-root-path) "articles")))

(current-language 'en)
(current-country 'fr)
(current-translations-dir "l10n/translations")
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
    (flush-output)
    (dispatcher req)))

(command-line
  #:once-each
  [("-p" "--port") port-arg
   "Open the server on a specific port"
   (let ([port (string->number port-arg)])
     (if (and port
              (exact-positive-integer? port)
              (port . <= . 65535))
        (server-port port)
        (raise-user-error 'wrong-port "Port should be an integer between 1 and 65535 (given: ~a)" port-arg)))]
  [("-a" "--address") address
   "Listen on a specific IP address"
   (server-listen-ip address)])

(define article-db (new article-db% [path article-root-path]))
(send article-db start)

(serve/servlet
  (wrap-in-logger blog-dispatcher)
  #:command-line? #t
  #:banner? #t
  #:servlet-regexp #rx""
  #:listen-ip (server-listen-ip)
  #:port (server-port)
  #:manager (create-none-manager response-not-found)
  #:servlet-responder (if-debug servlet-error-responder response-error)
  #:server-root-path (server-root-path)
  #:extra-files-paths (list static-root-path)
  #:file-not-found-responder response-not-found)
