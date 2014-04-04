require './Case.rb'

class Ligne

	@cases
	
	def initialize(uneTaille)
	
		@cases = Array.new()
		
		0.upto(uneTaille){|x|
		
			@cases.push(Case.new())
		}
	end
end
