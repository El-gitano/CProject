class Statistiques

	@stats

	attr_accessor :stats

	private_class_method :new

	def Statistiques.ouvrir(stats)
	
		new(stats)
	end

	def initialize(stats)
	
		@stats = stats
	end

	def maj(cle, donnee)
	
		@stats[cle]=donnee	
	end

end
