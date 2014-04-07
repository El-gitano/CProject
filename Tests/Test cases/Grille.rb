require './Case.rb'

class Grille

	@cases
	@taille
	
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
	
		x = 0
		
		operationGrille{|laCase|
		
			if (x % @taille) == 0 then
			
				print "\nLigne numero #{x/@taille + 1}\n\n"
			end
			
			print laCase.to_s + "\n"
			
			x += 1	
		}
		
		return nil
	end
	
	def to_debug
	
		x = 0
		
		operationGrille{|laCase|
		
			if (x % @taille) == 0 then
			
				print "\n"
			end
			
			print laCase.to_debug
			
			x += 1	
		}
		
		print "\n\n"
		
		return nil
	end
end
