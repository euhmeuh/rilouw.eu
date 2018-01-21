#lang racket/base

(provide render-index)

(require
  racket/list
  "_base.rkt"
  "../entities/blog.rkt")

(define links
  (list
    (link "Vegetables" "#vegetables")
    (link "Fruits" "#fruits")
    (link "About" "#about")))

(define articles
  (list (make-article "Vegetables"
          '(p "I love vegetables.")
          '(p "abcdefghijklmnopqrstuvwxyz")
          '(p "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefgh")
          '(h3 "Especially")
          '(p "Bla bla bla...")
          '(p "Bla bla."))
    (make-article "Fruits"
      '(p "I also like fruits.")
      '(h3 "Especially")
      '(p "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
          "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
      '(aside (p "Note to self: add some content here."))
      '(p "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
          "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."))))

(define (render-articles articles)
  (define (render-article article)
    `(article
      (h2 ([id ,(article-id article)]) ,(article-title article))
      ,@(article-body article)))
  (define separator '(hr ([class "fancy"])))
  (add-between (map render-article articles) separator))

(define (render-index)
  (render-base "Hello Rilouw!" links
    (lambda ()
      `(main ,@(render-articles articles)))))
