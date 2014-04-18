require './Modeles/Grilles/Grille'
require './Modeles/Grilles/Etats Cases/EtatCaseJouee'
require './Modeles/Grilles/Etats Cases/EtatCaseNeutre'

class GrilleEditeur < Grille

	def GrilleEditeur.Creer(uneTaille)
	
		new(uneTaille)
	end
	
	def initialize(uneTaille)
	
		super(uneTaille)
	end
	
	def genererAleatoire
	
		operationGrille{|uneCase|
		
			nbAleat = rand(2)
			
			case nbAleat
			
				when 0 then
				
					uneCase.changerEtat(EtatCaseJouee.getInstance)
			
				when 1 then
				
					uneCase.changerEtat(EtatCaseNeutre.getInstance)
			end		
		}
	end
end
