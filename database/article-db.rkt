#lang racket/base

(provide
  article-db%)

(require
  racket/list
  racket/class
  racket/contract
  anaphoric
  rilouw-website/entities/blog)

(define (article-file? path)
  (regexp-match? #rx"\\.art$" path))

(define (load-article path)
  (dynamic-require path 'article))

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

    (define/public (get-public-articles)
      (sort (filter (not/c draft?) articles)
            pubdate>?
            #:key article-date))

    (define/public (find-article-by-id id)
      (findf
        (lambda (article)
          (eq? (article-id article) id))
        (get-public-articles)))

    (define/public (find-articles-tagged tag)
      (define found-articles
        (filter (lambda (article)
                  (memq tag (article-tags article)))
                (get-public-articles)))
      (if (empty? found-articles)
          #f
          found-articles))

    (define/public (get-recent-articles)
      (get-public-articles))

    (define/public (get-frequent-tags #:at-least [at-least 2])
      (map car (filter (lambda (tag)
                         (>= (cdr tag) at-least))
                       (count-tags (get-public-articles)))))

    (define/private (load-articles)
      (set! articles
        (for/list ([article-path (in-directory path)]
                   #:when (article-file? article-path))
          (load-article article-path))))
    ))
