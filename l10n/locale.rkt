#lang racket/base

(require
  racket/contract/base
  web-server/http
  anaphoric)

(provide
  loc)

(provide/contract
  [load-locales! (-> void?)]
  [current-locale-dir parameter?]
  [locale (-> symbol? string?)]
  [request-locale (-> request? string?)])

(require
  "../utils.rkt")

(define current-locale-dir (make-parameter "locales"))

(define locales (make-hash))

(define (load-locales!)
  (for ([path (in-directory (current-locale-dir) sexp-file?)])
    (hash-set!
      locales
      (filename path)
      (make-hash (read-sexp-file path)))))

(define (locale id . args)
  (define locale (or (hash-ref locales (current-locale) #f)
                     (hash-ref locales "en" #f)
                     (error 'no-locale)))
  (apply format (cons (hash-ref locale id (format "/!\\~a/!\\" id))
                      args)))

(define-syntax-rule (loc id arg ...)
  (locale 'id arg ...))

#|
  Get the locale from the subdomain of the host name
|#
(define (request-locale request)
  (define headers (request-headers/raw request))
  (define host (headers-assq* #"Host" headers))
  (define hostname (and host (header-value host)))
  (or (and hostname
           (aif (regexp-match #rx"^([a-z]+)\\..+" hostname)
                (bytes->string/utf-8
                  (cadr it)) ;; the second element is the first group matched
                #f))
      (current-locale)))
