require './EtatCase.rb'
require './EtatCaseNeutre.rb'
require './EtatCaseJouee.rb'

class EtatCaseCroix < EtatCase
    
	@instance = nil
	
	private_class_method :new
	
	def initialize(uneCase)

		super(uneCase)	
	end
    
	def EtatCaseCroix.getInstance(uneCase)
	
		if @instance.nil? then
		
			@instance = new(uneCase)
		end
		
		return @instance
	end
	
	def clicDroit
	
		super()
		@case.changerEtat(EtatCaseNeutre.getInstance(@case))
	end
	
	def clicGauche
	
		super()
		@case.changerEtat(EtatCaseJouee.getInstance(@case))
	end
	
	def to_s
	
		return "Je suis une case avec une croix"
	end
end
