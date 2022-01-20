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
         (p "Racket Poetry is a way to express programs, games, demos... as poetry. Also, it's written in Racket, hence the name.")
         (p "Every line in your poem is an instruction for the computer, which is an old model from the 70s called CHIP-8. The system only detects some specific words as having meaning, and everything else in your sentence will be ignored, which allows for some creativity as you hide meaningful instructions into a lyrical sentence.")
         (p "You can try this here:")
         (a ([href "/poem"]) "ferale.art/poem")))))

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
