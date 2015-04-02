#encoding: UTF-8

require_relative 'Grille'

#La classe grilleJeu fournit une opération de réinitialisation de la grille en plus des fonctionnalités de base d'une grille
class GrilleJeu < Grille

	def GrilleJeu.Creer(taille, nomGrille, createur, nbJokers)
	
		new(taille,nomGrille,createur,nbJokers)
	end
	
	def initialize(taille,nomGrille,createur,nbJokers)
	
		super(taille,nomGrille,createur,nbJokers)
	end

	#Réinitialise l'ensemble des informations d'une grille
	def reinitialiserGrille
	
		
	end
	
	#Remet toutes les cases d'une grille à l'état neutre
	def reinitialiserCases
	
		operationGrille{|uneCase|
		
			uneCase.changerEtat(EtatCaseNeutre.getInstance)
		}
	end
end
