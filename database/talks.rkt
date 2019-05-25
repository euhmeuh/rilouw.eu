#lang racket/base

(provide
  events
  talks)

(require
  (only-in rilouw-website/entities/blog
           event
           talk))

(define events (hasheq
  'fosdem (event #:name "FOSDEM 2019" #:dates (cons "2019-02-02" "2019-02-03"))
  ))

(define talks
  (list

    (talk
      #:name "Why JSON when you can DSL?"
      #:desc "Creating small languages that fit your needs using Racket."
      #:event (hash-ref events 'fosdem)
      #:links '("https://fosdem.org/2019/schedule/event/jsonwhendsl/"
                "https://github.com/euhmeuh/fosdem-2019-talk"))

    (talk
      #:name "Create your own language with Racket"
      #:desc "Step-by-step tutorial on how to make languages in Racket."
      #:event (hash-ref events 'fosdem)
      #:links '("https://fosdem.org/2019/schedule/event/makeownlangracket/"
                "https://github.com/euhmeuh/fosdem-2019-talk"))

  ))
