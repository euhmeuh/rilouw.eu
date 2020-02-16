#lang racket/base

(provide
  events
  talks)

(require
  (only-in rilouw-website/entities/blog
           event
           talk))

(define events (hasheq
  'fosdem19 (event #:name "FOSDEM 2019" #:dates (cons "2019-02-02" "2019-02-03"))
  'fosdem20 (event #:name "FOSDEM 2020" #:dates (cons "2020-02-01" "2020-02-02"))
  ))

(define talks
  (list

    (talk
      #:name "Making poetry with Racket"
      #:desc "Come and see how to make Poems that are also Code!"
      #:event (hash-ref events 'fosdem20)
      #:links '("https://fosdem.org/2020/schedule/event/racket_poetry/"
                "https://github.com/euhmeuh/racket-poetry"))

    (talk
      #:name "Why JSON when you can DSL?"
      #:desc "Creating small languages that fit your needs using Racket."
      #:event (hash-ref events 'fosdem19)
      #:links '("https://fosdem.org/2019/schedule/event/jsonwhendsl/"
                "https://github.com/euhmeuh/fosdem-2019-talk"))

    (talk
      #:name "Create your own language with Racket"
      #:desc "Step-by-step tutorial on how to make languages in Racket."
      #:event (hash-ref events 'fosdem19)
      #:links '("https://fosdem.org/2019/schedule/event/makeownlangracket/"
                "https://github.com/euhmeuh/fosdem-2019-talk"))

  ))
