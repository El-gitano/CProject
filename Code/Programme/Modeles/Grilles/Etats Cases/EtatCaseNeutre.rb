require './EtatCase'
require './EtatCaseJouee'
require './EtatCaseCroix'

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
	
	def neutre?
    
    	return true
    end
    
    def croix?
    
    	return false
    end
    
    def jouee?
    
    	return false
    end
    
	def to_s
	
		return "Je suis une case neutre"
	end
	
	def to_debug
	
		return ' N '
	end
end
