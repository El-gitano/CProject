require './Modeles/ModeleJeu.rb'
require './Modeles/ModeleAccueil.rb'
require './Modeles/ModeleDemarrage.rb'
require './Modeles/ModeleAvecProfil.rb'

modeleDem = ModeleDemarrage.new

modeleDem.chargerProfil("Nabo")

#modeleAcc = ModeleAccueil.new(modeleDem.profil)
#test = modeleAcc.listeSauvegardes

profil = modeleDem.profil

modelejeu = ModeleJeu.new(profil)
#test = modeleAccueil.listeSauvegardes

#print test
#modelejeu.nouvellePartie("nouvellePartie","toto666")
#modelejeu.nouvelleSauvegarde("Sauvegarde")

#grille = modeleedit.getGrille('magrilleAleat')
#grille.to_debug
modelejeu.chargerPartie("Sauvegarde")

print modelejeu
#modelejeu.remplacerSauvegarde("SauveTaMere")


