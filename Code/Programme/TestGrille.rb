require './Modeles/ModeleEditeur.rb'
require './Modeles/ModeleDemarrage.rb'

modeleAccueil = ModeleDemarrage.new
modeleAccueil.creerProfil("Toto")

modeleedit=ModeleEditeur.new('Pierre',15)
#modeleedit.sauvegarder('magrilleAleat')
modeleedit.charger('magrilleAleat')


#grille = modeleedit.getGrille('magrilleAleat')
#grille.to_debug

print modeleedit
print modeleedit.getCase(0,0)

