require './Modeles/Grilles/Grille.rb'

class GrilleJeu < Grille

	def GrilleJeu.Creer(taille, nomGrille, createur, nbJokers)
	
		new(taille,nomGrille,createur,nbJokers)
	end
	
	def initialize(taille,nomGrille,createur,nbJokers)
	
		super(taille,nomGrille,createur,nbJokers)
	end

	# Pour ControleurJeu
	def reinitialiserCases
		# Mettre toutes les cases à l'état neutre
	end
end
