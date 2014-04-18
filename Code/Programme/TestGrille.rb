require './Modeles/Grilles/GrilleEditeur.rb' 	

grille = GrilleEditeur.Creer(10)

grille.genererAleatoire
grille.to_debug

print "\n"

seri = grille.serialize




toto = Grille.deserialize(seri)
toto.to_debug
print "\n"
