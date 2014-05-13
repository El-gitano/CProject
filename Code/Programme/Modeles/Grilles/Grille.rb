#encoding UTF-8

require_relative 'Case'
require 'yaml'

class Grille
	
	@taille
	@cases
	@nomGrille
	@createur
	@nbJokers
	@dateCreation
	@dateModification
	
	attr_accessor :nomGrille, :createur, :nbJokers, :taille, :dateModification, :cases, :dateCreation
	
	private_class_method :new
	
	def initialize(taille, nomGrille, createur, nbJokers)
		
		@taille = taille
		@nomGrille = nomGrille
		@createur = createur
		@nbJokers = nbJokers
		@cases = Array.new(taille){Array.new(taille){Case.new}}
		@dateCreation = Time.now.strftime("%d/%m/%Y %H:%M")
		@dateModification = Time.now.strftime("%d/%m/%Y %H:%M")
	end
		
	def getCase(x, y)
	
		return @cases[x][y]
	end
	
	def getColonne(x)
		
		return @cases[x]
	end
	
	def getLigne(y)

		resultat = Array.new()
		
		@cases.each{|x|
		
			resultat.push(x[y])
		}
		
		return resultat
	end
	
	def operationGrille
	
		@cases.each{|x|
		
			x.each{|y|

				yield y
			}
		}
	end
	
	def operationLigne(y)
	
		getLigne(y).each{|el|

			yield el
		}
	end
	
	def operationColonne(x)
	
		getColonne(x).each{|el|
		
			yield el
		}
	end

	def casesSerialize()

		return YAML.dump(@cases)
	end
	
	def Grille.casesDeserialize(obj)
	
		return YAML.load(obj)
	end
	
	def to_num

	end

	def to_s
	
		0.upto(@taille-1){|y|
		
			print "Ligne #{y+1}\n\n"
			
			operationLigne(y){|uneCase|
			
				print " #{uneCase} "
			}
		}
		
		return nil
	end
	
	def to_debug
	
		0.upto(@taille-1){|y|
		
			print "\n"
			
			operationLigne(y){|uneCase|
			
				print uneCase.to_debug
			}
		}
		
		return nil
	end
end
