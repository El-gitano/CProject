#encoding: UTF-8

require_relative 'Grille'
require_relative 'EtatsCases/EtatCaseJouee'
require_relative 'EtatsCases/EtatCaseNeutre'

#La classe grilleEditeur fournit une opération de génration aléatoire de la grille en plus des fonctionnalités de base d'une grille
class GrilleEditeur < Grille

	#Création d'une grille
	def GrilleEditeur.Creer(taille, nomGrille, createur, nbJokers)
	
		new(taille,nomGrille,createur,nbJokers)
	end
	
	def initialize(taille, nomGrille, createur, nbJokers)
	
		super(taille, nomGrille, createur, nbJokers)
	end
	
	#Modifie aléatoirement l'état des cases de la grille
	def genererAleatoire
	
		operationGrille do |uneCase|
		
			nbAleat = rand(2)
			
			case nbAleat
			
				when 0 then
				
					uneCase.changerEtat(EtatCaseJouee.getInstance)
			
				when 1 then
				
					uneCase.changerEtat(EtatCaseNeutre.getInstance)
			end		
		end
	end
end

