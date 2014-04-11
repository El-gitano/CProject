class Statistiques

	@stats

	attr_reader :stats
	private_class_method :new

	def Statistiques.ouvrir(nom,stats)
		new(nom,stats)
	end

	def initialize(stats)
		@stats = Statistiques.ouvrir(stats)
	end

	def maj(cle,donnee)
		@stats[cle]=donnee	
	end

end
