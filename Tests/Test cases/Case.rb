require './EtatCaseNeutre.rb'

class Case

    @etat
    
    attr_accessor :etat
    
    def initialize
    
    	@etat = EtatCaseNeutre.getInstance(self)

    end
    
    def clicDroit

    	@etat.clicDroit
    end
    
    def clicGauche
    
    	@etat.clicGauche
    end
    
    def to_s
    
    	@etat.to_s
    end
    
    def changerEtat(unEtat)
    
    	@etat = unEtat
    end
end
