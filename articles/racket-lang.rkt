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

@p{The good news is that there is a family of languages that have been especially designed to create languages. It's called @'|lisp|.}

@p{In the lisp family, there are a lot of different languages. Some designed for science, some designed for learning computer science, some general purposed, and some "language oriented".}

@p{Racket is a language oriented language. It's my favorite lisp, and if you followed until now, you're now ready to discover some of the tricks that make this language incredibly powerful in creating domain specific languages, aka. DSL.}]

@section["Racket basics"

@p{}

]

]
