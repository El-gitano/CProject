require './Modeles/Modele'

class ModeleProfil < Modele

	@stats
	
	attr_reader :stats
	
	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
		@stats = @profil.donnees.stats
	end
	
	def reinitialiserStatistiques
	
		@stats.each_value{|x|
		
			x = 0
		}
		
		#Enregistrer dans la bdd
	end
	
	#Retourne vrai si un profil existe sous le nom passé en paramètre
	def profilExiste?(unProfil)
	
		return !requete("SELECT * FROM profil WHERE pseudo = '#{unProfil}'").empty?
	end
	
	#Change le nom d'un profil déjà existant
	def changerNomProfil(nouveauNom)
	
		requete("UPDATE profil SET pseudo = '#nouveauNom' WHERE pseudo = '@modele.profil.pseudo'")
		@profil.pseudo = nouveauNom
		lancerMaj
	end
end	
