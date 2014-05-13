require './Modeles/Grilles/Grille.rb'

class GrilleJeu < Grille

	def GrilleJeu.Creer(taille, nomGrille, createur, nbJokers)
	
		new(taille,nomGrille,createur,nbJokers)
	end
	
	def initialize(taille,nomGrille,createur,nbJokers)
	
		super(taille,nomGrille,createur,nbJokers)
	end

	#Remet toutes les cases d'une grille à l'état neutre
	def reinitialiserCases
	
		operationGrille{|uneCase|
		
			uneCase.etat = EtatCaseNeutre.getInstance
		}
	end
end
