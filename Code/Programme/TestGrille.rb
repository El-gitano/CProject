require './Modeles/Grilles/GrilleEditeur.rb' 	
require './Modeles/Grilles/InfosGrille.rb' 

grille = GrilleEditeur.Creer(10)

grille.genererAleatoire
grille.to_debug

print "\n"

seri = grille.serialize




toto = Grille.deserialize(seri)
toto.to_debug
print "\n"
infos = InfosGrille.new()
infos.genererInfos(toto)
infos.to_debug
print "\n";
