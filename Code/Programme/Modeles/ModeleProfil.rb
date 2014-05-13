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
	
	#Retourne les statistiques de tous les joueurs
	def infosStats
	
		req = requete("SELECT pseudo, (parties_terminees/parties_commencees) AS taux_reussite, temps_joue, joker_utilises, indices_utilises, nombre_clics, ragequits FROM stats INNER JOIN profil ON stats.id = profil.id")
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
