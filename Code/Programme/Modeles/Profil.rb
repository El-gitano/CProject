class Profil

	@nom
	@stats

	attr_reader :nom,:stats
	private_class_method :new

	def Profil.ouvrir(nom,stats)
		new(nom,stats)
	end

	def initialize(nom,stats)
		@nom = nom
		@stats = Statistiques.ouvrir(stats)
	end

end
