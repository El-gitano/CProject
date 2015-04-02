require_relative 'Statistiques'

#La classe profil contient un pseudo et des statistiques associées à ce pseudo, ainsi que les opérations de consultation/modification sur ceux-ci
class Profil

	@pseudo
	@donnees

	attr_accessor :pseudo

	private_class_method :new

	#Ouvre un profil ainsi que ses statistiques associées
	def Profil.ouvrir(pseudo, stats)
	
		new(pseudo, stats)
	end

	def initialize(pseudo, stats)
	
		@pseudo = pseudo
		@donnees = Statistiques.ouvrir(stats)
	end

	#Retourne les statistiques du profil
	def getStats
	
		return @donnees.stats
	end
	
	#Remplace les statistiques du profil par celles passées en paramètre
	def setStats(nouvellesStats)
	
		@donnees.stats = nouvellesStats
	end
end
