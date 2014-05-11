require './Modeles/Grilles/Grille.rb'
require './Modeles/Grilles/EtatsCases/EtatCaseJouee.rb'
require './Modeles/Grilles/EtatsCases/EtatCaseNeutre.rb'

class GrilleEditeur < Grille

	#Création d'une grille
	def GrilleEditeur.Creer(taille, nomGrille, createur, nbJokers)
	
		new(taille,nomGrille,createur,nbJokers)
	end
	
	def initialize(taille, nomGrille, createur, nbJokers)
	
		super(taille, nomGrille, createur, nbJokers)
	end
	
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

