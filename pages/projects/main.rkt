#lang racket/base

(provide
  projects-page
  racket-poetry-page
  ferale-page
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

(define (ferale-page db)
  (base-page db (tr ferale-title) '()
    (lambda ()
      `(main
         (h2 ,(tr ferale-title))
         (p "Ferale is a 16 bits homebrew computer made from standard logic gates. It has a custom processor architecture called Louve, a Forth-like operating system (more like a collection of programs) called Mésange, a graphics card called Alosa that can output 320x240 VGA in 64 colors, and an assembler called Bourdon.")
         (p "Ferale is currently being constructed (slowly).")
         (p "You can check out the project on Sourcehut:")
         (a ([href "https://git.sr.ht/~euhmeuh/ferale"]) "git.sr.ht/~euhmeuh/ferale")

         (h3 "Construction status")
         (ul
           (li "Louve - Architecture is defined, emulator works, electrically simulated implementation is starting, physical implementation is not started.")
           (li "Alosa - Architecture is not completely defined, emulator is wacky, electrically simulated implementation is well advanced, physical implementation is started (VGA output works !).")
           (li "Bourdon - Racket emulator works but I'm not satisfied. Racket assembler works but has rough corners. Forth emulator is getting there and is way quicker than the Racket version. Forth assembler is not started yet.")
           (li "Mésange - There's only an Hello world ASCII output demo for now (no graphics)."))

         (h3 "Goals")
         (p "With Ferale, I want to create a computer from the ground up, document everything on my way, and hopefully end up with the complete, human readable description of a working, low-tech, sustainable and cute little computer.")
         (p "More than a computer, I want to create a collection of knowledge that describes how to build such a machine and how it works, down to each and every logic gate.")
         (p "I also want to share this knowledge with everyone, so that people can learn how computers are made.")
         (p "Then maybe, they can realize how impossibily difficult modern ones are to make. How crazy expensive they are in terms of resources, and eventually decide to make and use smaller, more affordable ones.")
         (p "In a way, I'm trying to save some knowledge of computing, at least the parts I like, before everything crumbles (or before we get enslaved by rich people controlling the remaining machines).")
         (p "I'm also trying to make computing a thing people can take back the control of.")
         (p "And finally, I kinda like the personal journey this involves.")

         (h3 "Note about the license")
         (p "The project is licensed under the Anarchist Revolutionary License, which is a license I wrote because I don't give a fuck about licenses, because they have no freakin' legal value in most countries, including mine. The values I injected in this license are similar to the GNU Affero GPL, but I added a lot of stuff about protecting the environment, not hurting humans and stuff, so it's technically not open source nor free software. I don't care, it's the end of our civilisation anyways, people will eat each other, who fuckin' cares about licenses?")
         (p "The intended usage is for punks to build it in their anarchist communities, so, just go build this computer in your garage, I'll be glad.")
         (p "On the other hand, if you are a capitalist or an entrepreneur, you shall not use that project, and I count on my peers to get you beheaded in time.")))))

(define (saffimshij-page db)
  (base-page db (tr saffimshij-title) '()
    (lambda ()
      `(main
         (h2 ,(tr saffimshij-title))
         (p "Saff Imshij is a constructed language for witches. I'm currently documenting and gathering information about it, so there's more to come.")))))
