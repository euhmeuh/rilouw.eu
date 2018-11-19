#lang racket/base

(provide (except-out (all-from-out racket/base)
                     #%module-begin
                     date)
         (rename-out [module-begin #%module-begin])
         (all-from-out rilouw-website/entities/blog)
         (rename-out [inline-code ic])
         (rename-out [newline n])
         (rename-out [strong str]))

(require
  rilouw-website/entities/blog)

(define-syntax-rule (module-begin expr)
  (#%module-begin
    (provide article)
    (define article expr)))
