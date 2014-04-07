require './EtatCase.rb'
require './EtatCaseJouee.rb'
require './EtatCaseCroix.rb'

class EtatCaseNeutre < EtatCase

	@instance = nil
	
	private_class_method :new
    
	def EtatCaseNeutre.getInstance

		if @instance.nil? then
	
			@instance = new
		end
	
		return @instance
	end
	
	def clicDroit(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseCroix.getInstance)
	end
	
	def clicGauche(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseJouee.getInstance)
	end
	
	def to_s
	
		return "Je suis une case neutre"
	end
	
	def to_debug
	
		return ' N '
	end
end
