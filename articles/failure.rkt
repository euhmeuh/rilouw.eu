#lang s-exp "../database/article-lang.rkt"

(article "Le rapport à l'erreur" '(french workplace human-rights failure error agile methodology unit-tests tests TDD)
  (paragraph
    "L'erreur doit être un moteur, un moyen d'expression."
    "Ne plus avoir peur de ses erreurs (grâce à des «filets de protection» humains et techniques), "
    "c'est libérer son expressivité et permettre à l'innovation d'avoir lieu.")
  (paragraph
    "Les enfants son créatifs car on créé pour eux un environnement où ils peuvent expérimenter sans craintes. "
    "Les scientifiques sont créatifs car ils oublient de faire des choses «utiles» (comprendre «rentables») et se concentrent sur «essayer ce qui n'a pas encore été essayé». "
    "Chez Google, 9 projets sur 10 échouent.")
  (section "Chez les devs"
    (dotted-list
      "Unit tests"
      "Preuve formelle"
      "Méthodes agiles"
      "Cycle d'amélioration continue"))
  (section "Dans la vie"
    (paragraph "Le droit à l'erreur")
    (paragraph "Quid des erreurs préjudiciables ?"
               "Toutes les erreurs sont-elles pardonnables ?")
    (paragraph "Comment créer une société qui authorise l'erreur?"))
  (section "À recouper avec"
    (paragraph "Toutes les populations ont-elles autant le droit à l'erreur ? Les femmes ? Les noir·e·s ? Les pauvres ?"))
  (section "Références"
    (dotted-list
      (link "Vision de l'erreur à travers le monde (France/Japon/USA/...)" "#")
      (link "Évolution des tribunaux" "#")
      (link "Évolution des établissements pénitentiers" "#"))))
