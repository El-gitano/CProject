#encoding: UTF-8

require_relative 'ModeleAvecProfil'

# Le modèle d'accueil permet d'accéder à l'accueil et à son propre profil
class ModeleAccueil < ModeleAvecProfil

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
end
