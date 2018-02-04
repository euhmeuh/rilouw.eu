#lang s-exp "../database/article-lang.rkt"

(article "Vegetables & Fruits" '(english meta)
  (section "Vegetables"
    (paragraph "I love vegetables.")
    (paragraph "abcdefghijklmnopqrstuvwxyz")
    (paragraph "abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefgh")
    (section "Especially"
      (paragraph "Bla bla bla...")
      (paragraph "Bla bla.")))
  (section "Fruits"
    (paragraph "I also like fruits.")
    (section "Especially"
      (paragraph
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
        "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")
      (note "Note to self: add some content here."))
    (paragraph
      "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. "
      "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")))
