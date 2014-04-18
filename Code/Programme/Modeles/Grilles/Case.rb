require './Modeles/Grilles/EtatsCases/EtatCaseNeutre.rb'

class Case

    @etat
    
    attr_accessor :etat
    
    def initialize
    
    	@etat = EtatCaseNeutre.getInstance

    end
    
    def clicDroit

    	@etat.clicDroit(self)
    end
    
    def clicGauche
    
    	@etat.clicGauche(self)
    end
    
    def neutre?
    
    	return @etat.neutre?
    end
    
    def croix?
    
    	return @etat.croix?
    end
    
    def jouee?
    
    	return @etat.jouee?
    end
    
    def to_s
    
    	@etat.to_s
    end
    
    def to_debug
    
    	@etat.to_debug
    end
    
    def changerEtat(unEtat)
    
    	@etat = unEtat
    end
end
