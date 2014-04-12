require './Case'

class Grille

	@cases
	@taille
	
	attr_reader :taille
	
	private_class_method :new
	
	def initialize(taille)
	
		@cases = Array.new(taille){Array.new(taille){Case.new}}
		@taille = taille
	end
		
	def getCase(y, x)
	
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
