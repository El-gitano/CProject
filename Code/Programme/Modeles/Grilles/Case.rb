#encoding: UTF-8

require_relative 'EtatsCases/EtatCaseNeutre'

#Une case possède un état auquel elle délègue toutes les demandes qui lui sont faites excepté le fait de changer d'état
class Case

    @etat
    @x
    @y
    
    attr_reader :x, :y, :etat
    
    def initialize(x, y)
    
    	@x = x
    	@y = y
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
    
    def changerEtat(unEtat)
    
    	@etat = unEtat
    end
    
    def to_s
    
    	@etat.to_s
    end
    
    def to_debug
    
    	@etat.to_debug
    end
end
