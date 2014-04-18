require './ModeleAvecProfil'

class ModeleAccueil < ModeleAvecProfil

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
end
