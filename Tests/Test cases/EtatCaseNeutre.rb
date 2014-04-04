require './EtatCase.rb'
require './EtatCaseJouee.rb'
require './EtatCaseCroix.rb'

class EtatCaseNeutre < EtatCase

	@instance = nil
	
	private_class_method :new
	
	def initialize(uneCase)

		super(uneCase)	
	end
    
	def EtatCaseNeutre.getInstance(uneCase)

		if @instance.nil? then
	
			@instance = new(uneCase)
		end
	
		return @instance
	end
	
	def clicDroit
	
		super()
		@case.changerEtat(EtatCaseCroix.getInstance(@case))
	end
	
	def clicGauche
	
		super()
		@case.changerEtat(EtatCaseJouee.getInstance(@case))
	end
	
	def to_s
	
		return "Je suis une case neutre"
	end
end
