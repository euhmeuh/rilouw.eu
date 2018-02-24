#lang racket/base

(provide
  editor-page)

(require
  web-server/servlet
  web-server/formlets)

(define (editor-page self embed/url [article #f])
  `(div
     ,(format "~a" article)
     ,(embed-formlet embed/url
        (formlet
          (#%#
            (div (label "Title:") ,(=> input-string title))
            (div (label "Tags:") ,(=> input-string tags))
            (div (button ([type "submit"]) "Save"))
            (div (button ([type "submit"]
                          [formaction ,(embed/url
                                         (lambda (req)
                                           (self req (append article '(p)))))])
                         "Add paragraph")))
          (self (redirect/get) (list title tags))))))
