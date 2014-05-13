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
	
		#Génération des nouvelles statistiques
		newStats = Hash.new
		
		@stats.each_pair{|cle, valeur|

			valeur = 0 if not cle.eql?("id")
			newStats[cle] = valeur
		}

		@profil.donnees.stats = newStats
		@stats = newStats
		
		#Enregistrement dans la bdd
		sauvegarderProfil
		lancerMaj
	end
	
	def infosStats
	
		req = requete("SELECT (parties_commencees/parties_terminees)*100, temps_joue, joker_tulises, indices_utilises, nombre_clics, ragequits FROM stats WHERE id = (SELECT id FROM profil WHERE pseudo = '#{@profil.pseudo}'))")
		return req
	end
	#Retourne vrai si un profil existe sous le nom passé en paramètre
	def profilExiste?(unProfil)
	
		return !requete("SELECT * FROM profil WHERE pseudo = '#{unProfil}'").empty?
	end
	
	#Change le nom d'un profil déjà existant
	def changerNomProfil(nouveauNom)
	
		requete("UPDATE profil SET pseudo = '#{nouveauNom}' WHERE pseudo = '#{@profil.pseudo}'")
		requete("UPDATE grilleediter SET createur ='#{nouveauNom}' WHERE createur = '#{@profil.pseudo}'")
		@profil.pseudo = nouveauNom
		lancerMaj
	end
end	
