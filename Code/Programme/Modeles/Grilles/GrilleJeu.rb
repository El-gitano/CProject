require './Modeles/Grilles/Grille'

class GrilleJeu < Grille

	def GrilleJeu.Creer(uneTaille)
	
		new(uneTaille)
	end
	
	def initialize(uneTaille)
	
		super(uneTaille)
	end
end
