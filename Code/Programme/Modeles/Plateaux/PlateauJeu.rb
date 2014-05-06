require './Modeles/Grilles/GrilleJeu'

class PlateauJeu

	@timer
	@infosGrille
	
	
	def initialize
	
		@infosGrille = InfosGrille.new
		@timer = 0
	end
	
	def chargementGrille(uneGrille)
	
	end
	
	def chargerInfosGrille
	
		@infosGrille.genererInfos(@grille)	
	end

	# Pour ControleurJeu
	def estRempli?
		# Vérifier que toutes les cases ont un état différent de EtatNeutre
	end
end
