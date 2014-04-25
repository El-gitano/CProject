require './Modeles/Modele'
require './Grilles/GrilleEditeur'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < Modele
	
	@grille
	@nbJokers
	
	attr_reader :grille
	
	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
		@grille = GrilleEditeur.Creer(15)
		lancerMaj
	end

	def 
end
