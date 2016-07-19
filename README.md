Pour executer la comparaison entre une formule MONA (luaToMONA) et un automate (formulaGenerator):

Préciser la valeur de gamma dans :
  'luaToMONA/config.lua'
  puis : executer
  'luaToMONA/generateGPomset.lua'

Il faut egalement la préciser pour l'automate.
dans
  'formulaGenerator/config.lua'
  Il faut selectionner la formule a vérifier dans formulaGenerator :
  ex :  'Formule = "EX"  où EX correspond à la description de l'automate sous forme de fichier lua.'

  Ensuite il faut executer
    './monaToGraph.sh luaToMONA/mona/comparaison/comp'
  Ce script test la négation de l'équivalence. Dans le meilleur des cas, le résultat est vide, sinon il y a un contre exemple.
  Le resultat s'affiche dans '../graphs/whole_graph.dot'
