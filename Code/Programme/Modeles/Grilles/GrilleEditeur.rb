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
	
	def importerGrille(nomGrille)
		if File.exists?(nomGrille) then
			file = File.open(nomGrille, "r")
			tmp = Grille.plateauDeserialize(file)

			self.taille = tmp.taille
			self.cases = tmp.cases
			self.nomGrille = tmp.nomGrille
			self.createur = tmp.createur
			self.nbJokers = tmp.nbJokers
			self.dateCreation = tmp.dateCreation
			self.dateModification = tmp.dateModification

			file.close()
			return true
		else
			return false
		end
	end

	def exporterGrille(nomGrille)
			file = File.new(nomGrille, "w")

			tmp = plateauSerialize()

			file.puts(tmp)
			file.close()
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
