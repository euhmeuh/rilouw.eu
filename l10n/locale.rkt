#lang racket/base

(require
  racket/contract/base)

(provide
  loc)

(provide/contract
  [load-locales! (-> void?)]
  [current-locale-dir parameter?]
  [current-locale parameter?]
  [locale (-> symbol? string?)])

(require
  "../utils.rkt")

(define current-locale-dir (make-parameter "locales"))
(define current-locale (make-parameter 'en))

(define locales (make-hash))

(define (load-locales!)
  (for ([path (in-directory (current-locale-dir) racket-file?)])
    (call-with-input-file path
      (lambda (input)
        (hash-set!
          locales
          (string->symbol (filename path))
          (make-hash (read input)))))))

(define (locale id . args)
  (define locale (or (hash-ref locales (current-locale) #f)
                     (hash-ref locales 'en #f)
                     (error 'no-locale)))
  (apply format (cons (hash-ref locale id (format "/!\\~a/!\\" id))
                      args)))

(define-syntax-rule (loc id arg ...)
  (locale 'id arg ...))
