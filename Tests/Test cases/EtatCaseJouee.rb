require './EtatCase.rb'

class EtatCaseJouee < EtatCase
   
	@instance = nil
	
	private_class_method :new
    
	def EtatCaseJouee.getInstance
	
		if @instance.nil? then
		
			@instance = new
		end
		
		return @instance
	end
	
	def clicDroit
	
		super(uneCase)
	end
	
	def clicGauche
	
		super(uneCase)
	end
	
	def to_s
	
		return "Je suis une case jouee"
	end
	
	def to_debug
	
		return ' J '
	end
end


