#encoding: UTF-8

require_relative 'ModeleAvecProfil'

class ModeleAccueil < ModeleAvecProfil

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
end
