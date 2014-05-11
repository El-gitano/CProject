require './Modeles/ModeleJeu.rb'
require './Modeles/ModeleDemarrage.rb'
require './Modeles/ModeleAvecProfil.rb'

modeleAccueil = ModeleDemarrage.new

modeleAccueil.chargerProfil("Charles")

profil = modeleAccueil.profil

modelejeu = ModeleJeu.new("Daminou",profil,10)




#grille = modeleedit.getGrille('magrilleAleat')
#grille.to_debug
modelejeu.nouvellePartie("Nom Partie")

print modelejeu


