#lang racket/base

(provide (except-out (all-from-out racket/base)
                     #%module-begin)
         (rename-out (module-begin #%module-begin))
         (all-from-out "../entities/blog.rkt")
         (rename-out (newline n)))

(require
  "../entities/blog.rkt")

(define-syntax-rule (module-begin expr)
  (#%module-begin
    (provide article)
    (define article expr)))
