#!/usr/bin/env racket
#lang racket/base

(require
  racket/system
  racket/string
  racket/function
  command-tree)

(define dependencies
  (list "anaphoric"
        "web-galaxy"))

(define (call command . args)
  (system (apply format (cons command args)) #:set-pwd? #t))

(define (run-server [port #f])
  (define option (if port (format "--port ~a" port) ""))
  (call "/usr/bin/env SITE_MODE=prod racket ./server.rkt ~a" option))

(command-tree
  `([install ,(thunk (call "raco pkg install -u --auto --binary-lib --skip-installed ~a" (string-join dependencies)))]
    [dev     ,(thunk (call "racket ./server.rkt"))]
    [run     ,run-server]
    [test    ,(thunk (call "racket ./tests/test-all.rkt"))])
  (current-command-line-arguments))
