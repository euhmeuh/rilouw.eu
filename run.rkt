#lang racket/base

(require
  racket/cmdline
  racket/class
  net/url
  web-galaxy/translate
  web-galaxy/response
  web-galaxy/serve
  (only-in web-galaxy/renderer current-custom-renderers)
  racket-poetry/server
  rilouw-website/pages/index
  rilouw-website/pages/article
  rilouw-website/pages/projects/main
  rilouw-website/pages/talks
  rilouw-website/pages/404
  rilouw-website/pages/500
  rilouw-website/database/article-db
  rilouw-website/database/projects
  rilouw-website/database/talks
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
  (define articles (send article-db get-recent-articles))
  (response/page (index-page article-db articles)))

(define-response (article article-id)
  (define article (send article-db find-article-by-id article-id))
  (if article
      (response/page (article-page article-db article))
      (response-not-found req)))

(define-response (projects)
  (response/page (projects-page article-db projects)))

(define-response (racket-poetry)
  (response/page (racket-poetry-page article-db)))

(define-response (ferale)
  (response/page (ferale-page article-db)))

(define-response (saffimshij)
  (response/page (saffimshij-page article-db)))

(define-response (talks)
  (response/page (talks-page article-db talks)))

(define-response (tag the-tag)
  (define found-articles
    (send article-db find-articles-tagged the-tag))
  (if found-articles
      (response/page (tag-page article-db
                               the-tag
                               found-articles))
      (response-not-found req)))

(define-response (not-found)
  (response/xexpr
    #:code 404
    #:message #"Not found"
    #:preamble #"<!DOCTYPE html>"
    (not-found-page article-db)))

(define (response-error url exception)
  (log-error "~s" `((exn ,(exn-message exception))
                    (uri ,(url->string url))
                    (time ,(current-seconds))))
  (response/xexpr
    #:code 500
    #:message #"Internal server error"
    #:preamble #"<!DOCTYPE html>"
    (error-page article-db)))

(server-command-line)

(define article-db (new article-db% [path article-root-path]))
(send article-db start)

(parameterize ([current-server-static-paths (list static-root-path)]
               [current-not-found-responder response-not-found]
               [current-error-responder response-error]
               [current-custom-renderers `([,symbol? . ,render-tag])])
  (serve/all
    [GET ("") response-index]
    [POST ("poem") response-poem]
    [GET ("projects") response-projects]
    [GET ("projects" "racket-poetry") response-racket-poetry]
    [GET ("projects" "ferale") response-ferale]
    [GET ("projects" "saffimshij") response-saffimshij]
    [GET ("talks") response-talks]
    [GET ("article" (symbol-arg)) response-article]
    [GET ("tag" (symbol-arg)) response-tag]))
