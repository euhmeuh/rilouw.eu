#lang racket/base

(provide (except-out (all-from-out racket/base)
                     #%module-begin
                     date)
         (rename-out (module-begin #%module-begin))
         (all-from-out "../entities/blog.rkt")
         (rename-out (paragraph p))
         (rename-out (newline n)))

(require
  "../entities/blog.rkt")

(define-syntax-rule (module-begin expr)
  (#%module-begin
    (provide article)
    (define article expr)))
