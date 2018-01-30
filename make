#!/usr/bin/env racket
#lang racket/base

(require
  racket/system
  racket/string
  make)

(define dependencies
  (list "anaphoric"))

(define (call command . args)
  (system (apply format (cons command args)) #:set-pwd? #t))

(make
  (["install" () (call "raco pkg install --auto --skip-installed ~a" (string-join dependencies))]
   ["dev" () (call "/usr/bin/env DEBUG=true racket ./server.rkt")]
   ["run" () (call "racket ./server.rkt")]
   ["test" () (call "raco test ./tests/test-all.rkt")])
  (current-command-line-arguments))
