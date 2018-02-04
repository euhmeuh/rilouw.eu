#lang racket/base

(provide
  article-db%)

(require
  racket/list
  racket/class
  racket/contract
  anaphoric
  "../entities/blog.rkt")

(define (load-article path)
  (dynamic-require path 'article))

(define (racket-file? path)
  (regexp-match? #rx"\\.rkt$" path))

(define (count-tags articles)
  (define tags (make-hash))
  (for ([article articles])
    (for ([tag (article-tags article)])
      (aif (hash-ref tags tag #f)
           (hash-set! tags tag (add1 it))
           (hash-set! tags tag 1))))
  (hash->list tags))

(define article-db%
  (class object%
    (super-new)
    (init-field path)
    (field [articles '()])

    (define/public (start)
      (load-articles))

    (define/public (find-article-by-id id)
      (findf
        (lambda (article)
          (string-ci=? (article-id article) id))
        articles))

    (define/public (find-articles-tagged tag)
      (define found-articles
        (filter (lambda (article)
                  (memq tag (article-tags article)))
                articles))
      (if (empty? found-articles)
          #f
          found-articles))

    (define/public (get-recent-articles)
      (filter (not/c draft?) articles))

    (define/public (get-frequent-tags #:at-least [at-least 2])
      (map car (filter (lambda (tag)
                         (>= (cdr tag) at-least))
                       (count-tags articles))))

    (define/private (load-articles)
      (set! articles
        (for/list ([article-path (in-directory path racket-file?)])
          (load-article article-path))))
    ))
