require './InfosGrille.rb'
require './GrilleEditeur.rb'

print "\n\nDECLARATION GRILLE\n\n"

g = GrilleEditeur.Creer(5)
g.genererAleatoire
print g.to_debug

i = InfosGrille.new
i.genererInfos(g)
i.to_debug
