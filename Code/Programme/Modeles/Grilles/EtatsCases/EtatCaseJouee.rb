#encoding: UTF-8

require_relative 'EtatCase'

#Définition de la réaction d'une case aux clics lorsqu'elle est jouée
class EtatCaseJouee < EtatCase
   
	@@instance = nil
    
	def EtatCaseJouee.getInstance
	
		if @@instance.nil? then
		
			@@instance = new
		end
		
		return @@instance
	end
	
	#Passe à l'état croix
	def clicDroit(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseCroix.getInstance)
	end
	
	#Passage à l'état neutre
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


