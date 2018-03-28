#lang racket/base

(require
  racket/contract/base)

(provide/contract
  [racket-file? (-> path? boolean?)]
  [filename (-> path? string?)])

(require
  racket/path)

(define (racket-file? path)
  (regexp-match? #rx"\\.rkt$" path))

(define (filename path)
  (path->string
    (path-replace-extension
      (file-name-from-path path)
      #"")))
