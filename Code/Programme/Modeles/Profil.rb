require './Modeles/Statistiques'

class Profil

	@pseudo
	@donnees

	attr_accessor :donnees
	attr_accessor :pseudo

	private_class_method :new

	def Profil.ouvrir(pseudo, stats)
	
		new(pseudo, stats)
	end

	def initialize(pseudo, stats)
	
		@pseudo = pseudo
		@donnees = Statistiques.ouvrir(stats)
	end

end
