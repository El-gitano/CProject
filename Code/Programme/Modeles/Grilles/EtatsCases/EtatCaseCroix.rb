#encoding UTF-8

require_relative 'EtatCase'
require_relative 'EtatCaseNeutre'
require_relative 'EtatCaseJouee'

class EtatCaseCroix < EtatCase
    
	@@instance = nil
	
	private_class_method :new
    
	def EtatCaseCroix.getInstance
	
		if @@instance.nil? then
		
			@@instance = new
		end
		
		return @@instance
	end
	
	def clicDroit(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseNeutre.getInstance)
	end
	
	def clicGauche(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseJouee.getInstance)
	end
	
	def neutre?
    
    	return false
    end
    
    def croix?
    
    	return true
    end
    
    def jouee?
    
    	return false
    end
    
	def to_s

		return "Je suis une case avec une croix"
	end
	
	def to_debug

		return ' X '
	end
end
