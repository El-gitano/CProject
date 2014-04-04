require './EtatCase.rb'

class EtatCaseJouee < EtatCase
   
	@instance = nil
	
	private_class_method :new
	
	def initialize(uneCase)

		super(uneCase)	
	end
    
	def EtatCaseJouee.getInstance(uneCase)
	
		if @instance.nil? then
		
			@instance = new(uneCase)
		end
		
		return @instance
	end
	
	def clicDroit
	
		super()
	end
	
	def clicGauche
	
		super()
	end
	
	def to_s
	
		return "Je suis une case jouee"
	end
end


