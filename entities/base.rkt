#lang racket/base

(provide
  gen:renderer
  define-renderer
  render-element
  (struct-out container)
  render-elements
  (struct-out link)
  render-link
  render-tag

  (rename-out [make-pubdate pubdate])
  pubdate?
  pubdate-year
  pubdate-month
  pubdate-day
  render-pubdate
  format-pubdate

  pubdate<=?
  pubdate<?
  pubdate=?
  pubdate>=?
  pubdate>?
  newline
  strong)

(require
  (for-syntax racket/base
              racket/syntax
              syntax/parse)
  racket/generic
  "urls.rkt")

(define-generics renderer
  (render renderer))

(define-syntax (define-renderer stx)
  (define-splicing-syntax-class name-maybe-parent
    (pattern (~seq name:id parent:id))
    (pattern name:id))
  (syntax-parse stx
    [(_ nmp:name-maybe-parent (field ...) body ...)
     #:with function-name (format-id stx "render-~a" #'nmp.name)
     #`(begin
         (struct #,@ #'nmp (field ...)
          #:methods gen:renderer
          [(define (render nmp.name)
            ((function-name) nmp.name))])
         (define function-name
           (make-parameter (lambda (nmp.name) body ...))))]))

(define (render-element element)
  (cond
    [(renderer? element) (render element)]
    [(symbol? element)
      ((render-tag) element)]
    [else element]))

(struct container (elements))

(define (render-elements container)
  (map render-element (container-elements container)))

(define-renderer link (text url)
  `(a ([href ,(link-url link)]) ,(link-text link)))

(define render-tag
  (make-parameter
    (lambda (symbol)
      (render-element (link (symbol->string symbol)
                            (make-tag-url symbol))))))

(define-renderer pubdate (year month day)
  (define day (pubdate-day pubdate))
  (define the-date (pubdate->date pubdate))
  `(time ([datetime ,(format-date the-date (if day 'iso 'iso-month))])
         ,(format-date the-date (if day 'full 'month))))

(define (make-pubdate year month [day #f])
  (pubdate year month day))

(define (pubdate->date pubdate)
  (local-require (only-in srfi/19 make-date))
  (make-date 0 0 0 0 (pubdate-day pubdate)
                     (pubdate-month pubdate)
                     (pubdate-year pubdate) 0))

(define ((make-pubdate-comparator comp) a b)
  (local-require (only-in srfi/19 date->julian-day))
  (comp (date->julian-day (pubdate->date a))
        (date->julian-day (pubdate->date b))))

(define pubdate<=? (make-pubdate-comparator <=))
(define pubdate<? (make-pubdate-comparator <))
(define pubdate=? (make-pubdate-comparator =))
(define pubdate>=? (make-pubdate-comparator >=))
(define pubdate>? (make-pubdate-comparator >))

(define pubdate-formats
  #hash([iso   . "~1"]
        [full  . "~A, ~B ~e, ~Y"]
        [iso-month . "~Y-~m"]
        [month . "~B ~Y"]))

(define (format-pubdate pubdate format)
  (format-date (pubdate->date pubdate) format))

(define (format-date date format)
  (local-require (only-in srfi/19 date->string))
  (date->string date (hash-ref pubdate-formats format)))

(define (newline)
  '(br))

(define (strong . text)
  `(strong ,@text))
