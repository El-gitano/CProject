#encoding: UTF-8

require_relative 'EtatCase'
require_relative 'EtatCaseJouee'
require_relative 'EtatCaseCroix'

#Définition de la réaction d'une case aux clics lorsqu'elle est neutre
class EtatCaseNeutre < EtatCase

	@@instance = nil
    
	def EtatCaseNeutre.getInstance

		if @@instance.nil? then
	
			@@instance = new
		end
	
		return @@instance
	end
	
	#Passage à l'état croix
	def clicDroit(uneCase)
	
		super(uneCase)
		uneCase.changerEtat(EtatCaseCroix.getInstance)
	end
	
	#Passage à l'état joué
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
