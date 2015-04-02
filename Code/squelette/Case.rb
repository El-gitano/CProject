require './EtatCaseNeutre.rb'

class Case

    @etat
    @x
    @y
    
    attr_accessor :etat
    
    def initialize(x, y)
    
    	@etat = EtatCaseNeutre.getInstance(self)
    	@x = x
    	@y = y
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
