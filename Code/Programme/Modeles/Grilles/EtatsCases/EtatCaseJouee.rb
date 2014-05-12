require './Modeles/Grilles/EtatsCases/EtatCase.rb'

class EtatCaseJouee < EtatCase
   
	@@instance = nil
    
	def EtatCaseJouee.getInstance
	
		if @@instance.nil? then
		
			@@instance = new
		end
		
		return @@instance
	end
	
	def clicDroit(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseCroix.getInstance)
	end
	
	def clicGauche(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseNeutre.getInstance)
	end
	
	def neutre?
    
    	return false
    end
    
    def croix?
    
    	return false
    end
    
    def jouee?
    
    	return true
    end
    
	def to_s
	
		return "Je suis une case jouee"
	end
	
	def to_debug
	
		return ' J '
	end
end


