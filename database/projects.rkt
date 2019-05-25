#lang racket/base

(provide projects)

(require
  rilouw-website/entities/blog)

(define projects
  (list
    (project
      #:name "web-galaxy"
      #:date (pubdate 2018 4)
      #:desc "Minimalist web framework for Racket."
      #:logo "web-galaxy-logo.svg"
      #:links '("https://github.com/euhmeuh/web-galaxy")
      '(p "This comes batteries included with all you need to create web content and serve it."))

    (project
      #:name "RilouwOS"
      #:date (pubdate 2018 12)
      #:desc "Minimalist free and open source operating system for cheap feature-phones, written in Forth."
      #:logo "rilouwos-logo.svg"
      #:links '("https://github.com/euhmeuh/rilouwos")
      '(p "It aims to empower users with an extremely simple and performant mobile OS with the minimal required features (calls, messages, contact list and alarm clock)."))

    (project
      #:name "Rilouworld"
      #:date (pubdate 2017 11)
      #:desc "Decentralized game universe in which players can explore worlds made by others."
      #:logo "rilouworld-logo.svg"
      #:links '("https://github.com/euhmeuh/rilouworld")
      '(p "I want to use ActivityPub as a mean to exchange small games in the fediverse."))

    (project
      #:name "bonny"
      #:date (pubdate 2018 2)
      #:desc "Website native container management in Racket."
      #:logo "bonny-logo.svg"
      #:links '("https://github.com/euhmeuh/bonny")
      '(p "Serves as a load balancer, reverse proxy, and metrics platform."))

    ;(project
    ;  #:name "Ril011w"
    ;  #:date (pubdate 2018 5)
    ;  #:desc "8-bit micro-computer based on the 6802 and talking in Toki Pona"
    ;  #:logo "ril011w-logo.svg"
    ;  #:links '("https://github.com/euhmeuh/ril011w"
    ;            "https://github.com/euhmeuh/virtual-mpu"))

    ;; --- Old projects ---

    (project
      #:name "Final Experience Quest"
      #:date (pubdate 2017 4)
      #:desc "XML quest engine for Final Experience, written in Python."
      #:discontinued? #t
      #:links '("https://github.com/euhmeuh/fxpq")
      '(p "It was supposed to be an editor for the game assets, using Tcl/tk for the GUI. But then I discovered Racket, s-expressions, and left XML behind."))

    (project
      #:name "Final Experience II"
      #:date (pubdate 2010 2)
      #:desc "Multiplayer platforming RPG written in Python using pygame."
      #:discontinued? #t
      #:links '("https://github.com/euhmeuh/fxp2"
                "https://sourceforge.net/projects/fxp2")
      '(p "It was a bit too ambitious. The Sourceforge link is for the old C version."))

    (project
      #:name "Final Experience I"
      #:date (pubdate 2008 1)
      #:desc "Top-down 2D RPG made with RPGMaker when I was in secondary school."
      #:discontinued? #t
      '(p "I distributed copies through USB keys. It had quite a success. I can't seem to find it again. I guess it's lost."))

    ))
