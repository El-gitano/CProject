#encoding: UTF-8

require_relative 'ModeleAvecProfil'

#Le modèle de démarrage permet au profil d'effectuer des intéraction avec la partie Profil de notre Bdd
class ModeleDemarrage < ModeleAvecProfil
	
	public_class_method :new
	
	def initialize
	
		super(nil)		
	end
end
