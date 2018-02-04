#lang s-exp "../database/article-lang.rkt"

(article "Hello world!" '(english meta)
  (paragraph
    "Hello world! I'm Jérôme, professional developer and hacker." (n) (n)
    "This is my brand new blog where I talk about " 'slow-tech ", " 'DIY " projects, " 'feminism ", " 'ecology ", metaphysical aspects of life..." (n) (n)
    "I wanted to make a blog from scratch using " 'Racket ", to see how simple and stupid you can keep a web server when using a " 'lisp " language. " (n) (n)
    "Feel free to pick up whatever you please, get inspired, and share your thought around."))
