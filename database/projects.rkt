#lang racket/base

(provide projects)

(require
  rilouw-website/entities/blog)

(define projects
  (list
    ;; --- Dedicated projects ---

    (project
      #:name "Ferale"
      #:date (pubdate 2018 5)
      #:desc "16-bit homebrew micro-computer for artistic purposes. It's my attempt at making a computer from logic gates, build it, and use it."
      #:logo "ferale-logo.svg"
      #:links '(("/projects/ferale" . "Details")))

    (project
      #:name "Racket poetry"
      #:date (pubdate 2020 2)
      #:desc "Poetry that compiles to CHIP-8 assembly so that you can make fun and artsy demos and games."
      #:links '(("/projects/racket-poetry" . "Details")
                ("/poem" . "Try it")))

    (project
      #:name "Saff Imshij"
      #:date (pubdate 2019 12)
      #:desc "The language of witches and the world around them. It's a constructed language packed with natural elements, religions, ceremonies, rituals.. Even some animals use it and you can cast spells and stuff."
      #:logo "saffimshij-logo.svg"
      #:links '(("/projects/saffimshij" . "Details")))

    ;; --- Projects ---

    (project
      #:name "web-galaxy"
      #:date (pubdate 2018 4)
      #:desc "Minimalist web framework for Racket."
      #:logo "web-galaxy-logo.svg"
      #:links '("https://github.com/euhmeuh/web-galaxy")
      '(p "This comes batteries included with all you need to create web content and serve it."))

    ;; --- Old projects ---

    (project
      #:name "bonny"
      #:date (pubdate 2018 2)
      #:desc "Website native container management in Racket."
      #:logo "bonny-logo.svg"
      #:status 'on-hold
      #:links '("https://github.com/euhmeuh/bonny")
      '(p "Serves as a load balancer, reverse proxy, and metrics platform."))

    (project
      #:name "RilouwOS"
      #:date (pubdate 2018 12)
      #:desc "Minimalist free and open source operating system for cheap feature-phones, written in Forth."
      #:logo "rilouwos-logo.svg"
      #:status 'on-hold
      #:links '("https://github.com/euhmeuh/rilouwos")
      '(p "It aims to empower users with an extremely simple and performant mobile OS with the minimal required features (calls, messages, contact list and alarm clock)."))

    (project
      #:name "Rilouworld"
      #:date (pubdate 2017 11)
      #:desc "Decentralized game universe in which players can explore worlds made by others."
      #:logo "rilouworld-logo.svg"
      #:status 'discontinued
      #:links '("https://github.com/euhmeuh/rilouworld")
      '(p "I want to use ActivityPub as a mean to exchange small games in the fediverse."))

    (project
      #:name "Final Experience Quest"
      #:date (pubdate 2017 4)
      #:desc "XML quest engine for Final Experience, written in Python."
      #:status 'discontinued
      #:links '("https://github.com/euhmeuh/fxpq")
      '(p "It was supposed to be an editor for the game assets, using Tcl/tk for the GUI. But then I discovered Racket, s-expressions, and left XML behind."))

    (project
      #:name "Final Experience II"
      #:date (pubdate 2010 2)
      #:desc "Multiplayer platforming RPG written in Python using pygame."
      #:status 'discontinued
      #:links '("https://github.com/euhmeuh/fxp2"
                "https://sourceforge.net/projects/fxp2")
      '(p "It was a bit too ambitious. The Sourceforge link is for the old C version."))

    (project
      #:name "Final Experience I"
      #:date (pubdate 2008 1)
      #:desc "Top-down 2D RPG made with RPGMaker when I was in secondary school."
      #:status 'discontinued
      '(p "I distributed copies through USB keys. It had quite a success. I can't seem to find it again. I guess it's lost."))

    ))
