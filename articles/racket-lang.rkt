#lang at-exp s-exp "../database/article-lang.rkt"

@article["The programming language of your dreams" @pubdate[2018 6 26] '(draft english technology programming racket lisp)

@p{For a long time, my favorite language was Python. It's fairly well designed and useful for any task,
   from web servers like Django to 3D software like Blender; from neural networks like TensorFlow to cloud computing platforms like OpenStack.}

@p{Python offers so much libraries and tools for a developer to play with that you feel you can achieve anything, given the right tool.}

@p{What I really enjoyed above all was the community, and the feeling that everyone was according to the same set of standards (it was of course not always the case)
   and that you could somehow easily agree on what was "Pythonic" and what was not (spoiler alert: in fact, you cannot).}

@p{Now that I shifted to using lisp languages (especially Racket), I see my past self as childish and primitive,
   but it has been a brease passing through Python as a part of my road to becoming
   a better developer, and alas I may never use Python again for personal projects,
   I have learned a lot and would still recommend it for anyone wanting to achieve efficiently, quickly and
   elegantly some IT project.}

@p{So what is so good in Racket, that it made me think I finally found the language of my dreams?}

@p{Well, there's a lot of features that make
   Racket an awesome language to work with: parameters, continuations, contracts, syntax-parse...
   But the feature I want to write about today is by far the one I find really transcendental: @inline-code{#lang} (pronounce "hash-lang").}

@p{@inline-code{#lang} allows writing your own languages. Let's dive into it!}

@(fold)

@section["The myth of the universal translator"

@p{Sometimes comes a task in your daily job that looks like there's something deeper going on.}

@p{Sometimes, you feel like your team would really benefit from a tool that could understand some simple data (XML, JSON, a database, whatever...) and execute
   some generic behavior depending on a configuration you can tweak.}

@p{It' easy, you say: I understand my job and my colleagues' job well, I'm sure I can find a common ground from which I could define generic behaviors, and then customize
   them with parameters.}

@p{Let's say you work in a game development studio. You have multiple teams (gameplay, engine, UI, network, 2D & 3D artists...etc) working together on a final product.
   You usually want to see what each of those teams are working on, preferably merged together in a bundle that would look as close as possible to what the final result should be.}

@p{To achieve that, you need build tools, communication tools, reports, tests, bundlers,
   a whole suite of custom software and I can certainly assert you have a lot of data files in different formats.}

@p{You say: I need a tool that would understand the needs of those teams, and translate them into computer logic so that everything can be compiled together.}

@p{I need a custom file format. It needs to be simple, it needs to be adapted to the vocabulary of the teams.}

@p{In fact, you could say that you need a kind of "universal translator". Not a translator for natural languages, say French, English, Japanese... But a translator for your teams' languages: 
   Gameplay-language, Artist-language, UI-language.}

@p{So you start designing what the UI-language could be:}

@code["XML"]{
   <ui>
     <menu id="title_menu">
       <button goto="campaign_menu">Campaign</button>
       <button goto="multiplayer_menu">Multiplayer</button>
       <button goto="credits_menu">Credits</button>
     </menu>
   </ui>
}

@p{Then design a way to make your software behave depending on that file.}

@p{If you're using a typed language like C# or Java,
   you're likely to make a @inline-code{UI} class, a @inline-code{Menu} class, a @inline-code{Button} class...etc}

@p{Soon you'll start to realize that the more you add classes, the more complexe your software becomes, and more bloated the scope reveals itself.}

@p{It may take years until you accept the sad truth that what you're trying to do is way out of your scope. You're making a software that permits non-technical users to express their
   specific needs in the vocabulary of their specific domain, while keeping everything together and doing the Right Thing™ every time, preferably in an automated fashion.}

@p{You are making the @strong{Universal Translator}.}

@p{The bad news is that most programming languages are not suited for programming that kind of software. Because actually, that's not a software you want to make, but a language.}

@p{The good news is that there is a family of languages that have been specifically designed to create languages. It's called @'|lisp|.}

@p{In the lisp family, there are a lot of different languages. Some designed for science, some designed for learning computer science, some general purposed, and some "language oriented".}

@p{Racket is a language oriented language. It's my favorite lisp, and if you followed until now, you're now ready to discover some of the tricks that make this language incredibly powerful in creating domain specific languages, aka. DSL.}]

@section["Common Lisp vs Scheme"

@p{Racket is an implementation of Scheme, which is one of the two major lisp families (the other one being Common Lisp).
   Both have been around for more than 50 years (you read that well) and mostly differ from each other in deep philosophical questions about whether or not
   we can implicitely introduce variables in scope without telling the user. This is known as "breaking hygiene" in Scheme, or as "anaphoric awesomeness" in Common Lisp
   (note that the vocabulary difference says it all about what each community think of this practice).}

@p{Scheme says no, you can't break hygiene (except maybe sometimes but don't tell my mom), Common Lisp says yes, of course you can, that's an awesome feature (it is).
   That's about it. There are some other differences but really, unless you are deeply interested in lisp design, you don't care (for now).}

@p{Racket says: With great power comes great responsibility. I'm Scheme-based, so let's not break hygiene by default. But let's allow breaking hygiene step by step,
   by building a framework that prevents things from getting hairy, but still unlock the awesomeness of anaphoric macros.}

@p{If I'm writing about Racket today, that's (among other reasons) because I think that's the right approach. The only drawback is that it makes learning Racket
   macros a bit difficult for beginners. But in the long time, it really pays off.}]

@section["Lists and atoms"

@p{Coming back to what lisp looks like. There is no exact definition of what a lisp is or is not, but you can usually recognize them at their famous @inline-code{((((parentheses))))}.}

@p{The format in which one writes lisp is called "s-expressions" or "s-exp" and is the basic skeleton from which you write a program. It's a list of lists of lists of lists...etc}

@p{It looks like this:}

@code["lisp"]{
  (always (walk (forest (random-trees)))
    (let mushroom (fetch (forest-ground))
      (when (comestible? mushroom)
        (put mushroom -> basket))))
}

@p{You can nearly smell the spicy scent of pine in that piece of code. Half code, half poem, I'd dare say.}

@p{A list is a pair of parentheses @inline-code{(...)} and everything that is not
   blank spaces nor parentheses is called an "atom":
   @inline-code{always}, @inline-code{comestible?}, @inline-code{->}, @inline-code{forest}, @inline-code{basket}, @inline-code{mushroom}...}

@p{Atoms can contain any characters in Racket, even symbols like @inline-code{%}, @inline-code{_}, @inline-code{-}, @inline-code{+}, @inline-code{~}, @inline-code{&}, @inline-code{@"@"}, @inline-code{=}, whatever you like.}

@p{This is because lists and atoms are the @strong{only} piece of syntax hardcoded in the language.
   Everything else is defined by programmers. The @inline-code{if} clause, variable definitions, classes if you want classes, structs if you want structs...}

@p{The language can be object oriented if you want. Functional if you want. It can be your own language. You are the one defining the rules and the syntax.}

@p{This is why the first example I gave is written in a language which is not Racket, nor Scheme, nor Common Lisp.
   It's just one kind of lisp I just made up to best express my desire of fetching mushrooms in the forest.}

@p{This lack of formal syntax allows two things:}

@dotted-list[
  "The language can be whatever you like"
  "The language can parse itself as data"]

@p{The second point is the most important thing to understand. Instead of using some kind of file format for your data, you can actually write your data as code.
   Because there is no fundamental difference between a piece of code like @inline-code{(send love letters)} and a listing of data like @inline-code{(banana apple pear)}.
   Both are lists holding three atoms. As a programmer, you are the one defining their meaning.}

@p{Therefore, you can write JSON as lisp, HTML as lisp, even Javascript as lisp:}

@code["JSON-lisp"]{
  (users [
    (
      (name "Jane")
      (surname "Doe")
      (inventory [
        ((name "Life potion") (effect "HP_INC") (amount 10))
      ])
    )
    (
      (name "Hanako")
      (surname "Yamada")
      (inventory [
        ((name "Magic staff") (type "weapon") (damage 4))
      ])
    )
  ])
}

@p{NB: I indented it like JSON for the sake of the example, but usually lisp
   programmers care about their parentheses and don't like leaving them alone on their lines.}

@code["HTML-lisp"]{
  (html ([lang "en"])
    (head
      (title "My awesome blog about ponies"))
    (body
      (article ([class "first"])
        (p "I like all ponies.")
        (p "But my favorite one is: ")
        (a ([href "/favorite"]
            [class "rainbow-link"])
          "Click here to discover my favorite pony!!"))))
}

@p{The blog you are reading right now is actually written in this kind of HTML-lisp language.}

@code["Javascript-lisp"]{
  (function print_percentage (a b)
    (var result null)
    (try
     (set result (* (/ a b) 100))
     (catch (e)
       (console.log "Error: {}" e)
       (return false)))
    (console.log "Percentage is {}%" result)
    (return true))
}

@p{My point is: you do whatever you like with lisp, and give it the shape you like, regardless of the type of data/code you are working with.
   This makes it the perfect tool for glueing together different technologies, abstracting away different
   implementations or formats, or designing new languages for your teams.}

@p{For the more savvy of you, if you want the exact technical term that refers to
   this property of lisp to be at the same time code and data:
   it's called @link["Homoiconicity" "https://en.wikipedia.org/wiki/Homoiconicity"].}

@p{I can already hear you ask: But what is the point? Javascript is good as it is, I don't need this weird parentheses-everywhere syntax!}

@p{Well, the fact that this javascript code is also @strong{data} means you can edit and modify it on-the-fly.
   You can create new kinds of control words like @inline-code{do..until}, a truly working @inline-code{for-each}, some kind of integrated
   SQL query language @inline-code{(select * from users)} that would work on JSON-lisp. You name it.}

@p{You can do reflection on your own code:}

@console["Console"]{
  > (define code (read "percentage.js"))
  > (first code)
  'function

  > (second code)
  'print_percentage

  > (find 'console.log code)
  '((console.log "Error: {}" e)
    (console.log "Percentage is {}%" result))
}]

@p{All your code is editable as a list of atoms. It is normally very difficult to parse and modify
   Javascript because of its syntax (programmers of linters, minifiers or transpilers can testify), but
   with s-expressions, everything becomes a lot simpler.}

@section["Making languages with Racket"

@p{Remember the XML UI-language we wrote earlier so that our UI team can design interfaces? In lisp, it would look like this:}

@code["ui-lang"]{
  (ui
    (menu ([id "title_menu"])
      (button ([goto "campaign_menu"]) "Campaign")
      (button ([goto "multiplayer_menu"]) "Multiplayer")
      (button ([goto "credits_menu"]) "Credits")))
}

@p{Let's write a Racket module that can parse and display that!}

]

]
