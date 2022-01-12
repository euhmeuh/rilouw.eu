#lang racket/base

(provide
  projects-page
  racket-poetry-page
  ril011w-page
  saffimshij-page)

(require
  (only-in web-galaxy/translate tr)
  rilouw-website/pages/base
  rilouw-website/entities/blog)

(define (render-project-links links)
  `(ul ,@(map (lambda (link)
                `(li ([class "big"])
                   ,(if (pair? link)
                        `(a ([href ,(car link)]) ,(cdr link))
                        `(a ([href ,link]) ,link))))
              links)))

(define (render-project project)
  (define status (project-status project))
  `(section ([class ,(if status
                         "block block-grey"
                         "block")])
     (header ([class "flex"])
       (h3 ([id ,(symbol->string (project-id project))]
            [class "flex-1"])
          ,(project-name project))
       (aside ([class "flex-1"])
         ,(tr project-date)
         ,(render-element (project-date project))
         ,@(cond
             [(eq? status 'discontinued) (list (tr project-discontinued))]
             [(eq? status 'on-hold)      (list (tr project-on-hold))]
             [else '()])))
     (p ,(project-desc project))
     ,@(render-elements project)
     ,(render-project-links (project-links project))))

(define (projects-page db projects)
  (base-page db (tr projects-title) '()
    (lambda ()
      `(main
         (h2 ,(tr projects-title))
         ,@(map render-project projects)))))

(define (racket-poetry-page db)
  (base-page db (tr racket-poetry-title) '()
    (lambda ()
      `(main
         (h2 ,(tr racket-poetry-title))
         (p "Racket Poetry")))))

(define (ril011w-page db)
  (base-page db (tr ril011w-title) '()
    (lambda ()
      `(main
         (h2 ,(tr ril011w-title))
         (p "RIL011W")))))

(define (saffimshij-page db)
  (base-page db (tr saffimshij-title) '()
    (lambda ()
      `(main
         (h2 ,(tr saffimshij-title))
         (p "Saff Imshij")))))
