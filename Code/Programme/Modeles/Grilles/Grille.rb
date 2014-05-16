#encoding: UTF-8

require_relative 'Case'
require 'yaml'

#Une grille est composée d'une ensemble de cases ainsi que de diverses informations telles que sa taille, son nom...
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
		initGrille(taille)
		@dateCreation = Time.now.strftime("%d/%m/%Y %H:%M")
		@dateModification = Time.now.strftime("%d/%m/%Y %H:%M")
	end
	
	#Initialise la grille (donne des indices au cases)
	def initGrille(taille)
	
		@cases = Array.new
		
		0.upto(taille-1){|x|
		
			colonne = Array.new
			
			0.upto(taille-1){|y|
		
				colonne.push(Case.new(x, y))
			}
			
			@cases.push(colonne)
		}
	end
		
	#Retourne une case de la grille (de la classe Case)
	def getCase(x, y)
	
		return @cases[x][y]
	end
	
	#Retourne la colonne x de cases de la grille
	def getColonne(x)
		
		return @cases[x]
	end
	
	#Retourne la ligne y de cases de la grille
	def getLigne(y)

		resultat = Array.new()
		
		@cases.each{|x|
		
			resultat.push(x[y])
		}
		
		return resultat
	end
	
	#Effectue une opération sur l'ensemble de la grille. Cette opération est un bloc passé en paramètre
	def operationGrille
	
		@cases.each{|x|
		
			x.each{|y|

				yield y
			}
		}
	end
	
	#Effectue une opération sur la ligne y de la grille. Cette opération est un bloc passé en paramètre
	def operationLigne(y)
	
		getLigne(y).each{|el|

			yield el
		}
	end
	
	#Effectue une opération sur la colonne x de la grille. Cette opération est un bloc passé en paramètre
	def operationColonne(x)
	
		getColonne(x).each{|el|
		
			yield el
		}
	end

	#Serialise les cases de la grille afin de les sauvegarder dans la bdd
	def casesSerialize()

		return YAML.dump(@cases)
	end
	
	#Déserialise une grille afin de la charger en mémoire
	def Grille.casesDeserialize(obj)
	
		return YAML.load(obj)
	end


	#Serialise les cases de la grille afin de les sauvegarder dans la bdd
	def plateauSerialize()

		return YAML.dump(self)
	end
	
	#Déserialise une grille afin de la charger en mémoire
	def Grille.plateauDeserialize(obj)
	
		return YAML.load(obj)
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
