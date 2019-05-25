#lang racket/base

(provide
  projects-page)

(require
  (only-in web-galaxy/translate tr)
  rilouw-website/pages/base
  rilouw-website/entities/blog)

(define (render-project-links links)
  `(ul ,@(map (lambda (link)
                `(li ([class "big"])
                     (a ([href ,link]) ,link)))
              links)))

(define (render-project project)
  (define discontinued? (project-discontinued? project))
  `(section ([class ,(if discontinued?
                         "block block-grey"
                         "block")])
     (header ([class "flex"])
       (h3 ([id ,(symbol->string (project-id project))]
            [class "flex-1"])
          ,(project-name project))
       (aside ([class "flex-1"])
         ,(tr project-date)
         ,(render-element (project-date project))
         ,@(if discontinued? (list (tr project-discontinued)) '())))
     (p ,(project-desc project))
     ,@(render-elements project)
     ,(render-project-links (project-links project))))

(define (projects-page db projects)
  (base-page db (tr projects-title) '()
    (lambda ()
      `(main
         (h2 ,(tr projects-title))
         ,@(map render-project projects)))))
