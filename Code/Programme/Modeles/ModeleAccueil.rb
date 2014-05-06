require './Modeles/ModeleAvecProfil'

class ModeleAccueil < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	def getProfil
	
		return @profil.pseudo
	end
end
