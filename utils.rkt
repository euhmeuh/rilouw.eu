#lang racket/base

(require
  racket/contract/base)

(provide/contract
  [racket-file? (-> path? boolean?)]
  [sexp-file? (-> path? boolean?)]
  [filename (-> path? string?)]
  [read-sexp-file (-> path? any/c)])

(require
  racket/path)

(define (racket-file? path)
  (regexp-match? #rx"\\.rkt$" path))

(define (sexp-file? path)
  (regexp-match? #rx"\\.sexp$" path))

(define (filename path)
  (path->string
    (path-replace-extension
      (file-name-from-path path)
      #"")))

(define (read-sexp-file sexp-file)
  (call-with-input-file sexp-file
    (lambda (in)
      (call-with-default-reading-parameterization
        (lambda () (read in))))))
