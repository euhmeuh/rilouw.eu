#lang racket/base

(provide (except-out (all-from-out racket/base)
                     #%module-begin
                     date)
         (rename-out (module-begin #%module-begin))
         (all-from-out "../entities/blog.rkt")
         (rename-out (paragraph p))
         (rename-out (newline n))
         (rename-out (make-date date)))

(require
  "../entities/blog.rkt")

(define-syntax-rule (module-begin expr)
  (#%module-begin
    (provide article)
    (define article expr)))

(define (make-date year month day)
  (local-require gregor)
  (date year month day))
