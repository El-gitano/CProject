require './Modeles/Grilles/Grille.rb'

class GrilleJeu < Grille

	def GrilleJeu.Creer(uneTaille)
	
		new(uneTaille)
	end
	
	def initialize(uneTaille)
	
		super(uneTaille)
	end

	# Pour ControleurJeu
	def reinitialiserCases
		# Mettre toutes les cases à l'état neutre
	end
end
