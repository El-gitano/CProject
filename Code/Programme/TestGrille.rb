require './Modeles/ModeleJeu.rb'
require './Modeles/ModeleAccueil.rb'
require './Modeles/ModeleDemarrage.rb'
require './Modeles/ModeleAvecProfil.rb'

modeleDem = ModeleDemarrage.new

modeleDem.chargerProfil("Nabo")

modeleAcc = ModeleAccueil.new(modeleDem.profil)
test = modeleAcc.listeSauvegardes

#profil = modeleAccueil.profil

#modelejeu = ModeleJeu.new("Daminou",profil,10)
#test = modeleAccueil.listeSauvegardes

print test

#grille = modeleedit.getGrille('magrilleAleat')
#grille.to_debug
#modelejeu.nouvellePartie("Nom Partie")

#print modelejeu


