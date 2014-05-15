#encoding: UTF-8

require 'sqlite3'
require_relative 'Modele'

class ModeleAvecProfil < Modele
    
    @profil
    
    attr_reader :profil
    
    def initialize(unProfil)

		super()
        @profil = unProfil
    end
	
	#Retourne le pseudo du profil
	def getPseudo
	
		return @profil.pseudo
	end
	
	#Change le pseudo du profil actuel
	def changerPseudo(unPseudo)
	
		@profil.pseudo = unPseudo
	end
	
	#Met à jour le profil actuel ainsi que ses statistiques dans la base de donnée
    def sauvegarderProfil
		
		#Ajouter la modification du nom
		
		#Sauvegarde des stats
		0.upto(@profil.getStats.length/2) do |x|
	
			@profil.getStats.delete(x)
		end	

		id = @profil.getStats["id"]
		req = ""
		
		@profil.getStats.each do |key, value| 
	
			req += "'#{key}' = '#{value}', "
		end	
		
		req = req[0...-2]
		
		self.requete("UPDATE stats SET #{req} WHERE id = #{id}") 
	end
	
	#Crée un profil dans la base de donnée
    def creerProfil(unLogin)
		
        if not existeProfil?(unLogin) then
		
			#Création du profil
            requete("INSERT INTO profil(pseudo, pass) VALUES ('#{sanitize(unLogin)}', NULL)")
            id = requete("SELECT id from profil WHERE pseudo = '#{sanitize(unLogin)}'")[0]["id"]
            
            #Création des stats
            requete("INSERT INTO stats(id, parties_commencees, parties_terminees, temps_joue, joker_utilises, indices_utilises, grilles_crees, nombre_clics, ragequits) VALUES(#{id},0,0,0,0,0,0,0,0)")

		end
	end
	
	#Supprime unLogin de la base de donnée, retourne vrai en cas de succès, faux sinon
	def supprimerProfil(unLogin)
		
		if existeProfil?(unLogin) then

			id = requete("SELECT id from profil WHERE pseudo = '#{sanitize(unLogin)}'")[0]["id"]
			requete("DELETE FROM profil WHERE id = #{id}")
			requete("DELETE FROM stats WHERE id = '#{id}'")

		end
	end

 	#Cette méthode charge un profil à partir d'un pseudo en allant chercher dans la base de donnée
    def chargerProfil(unPseudo)

		#Récupération du profil dans des variables
       	stats = requete("SELECT * FROM stats WHERE id = (SELECT id FROM profil WHERE profil.pseudo = '#{sanitize(unPseudo)}')")
		
		#Chargement du profil
		@profil = Profil.ouvrir(unPseudo, stats[0])
   	end
	
	#Retourne vrai si le profil de pseudo "unLogin" existe, faux sinon
	def existeProfil?(unLogin)
	
		return !requete("SELECT * FROM profil WHERE pseudo = '#{sanitize(unLogin)}'").empty?
	end
	
	#Retourne la liste des profils de la bdd ordonnés de chronologique dans leurs création
	def listeProfils
	
		retour = Array.new
		
		res = requete "SELECT pseudo FROM profil ORDER BY id DESC"
		
		res.each{|x|
	
			retour.push(x["pseudo"])
		}	

		return retour
	end
	
	#Ajoute une création de grille aux statistiques du joueur
	def ajouterGrilleCree
	
		@profil.getStats["grilles_crees"] += 1
	end
	
	#Ajoute l'utilisation d'un indice aux statistiques du joueur
	def ajouterIndice
	
		@profil.getStats["indices_utilises"] += 1
	end
	
	#Ajoute l'utilisation d'un joker aux statistiques du joueur
	def ajouterJoker
	
		@profil.getStats["joker_utilises"] += 1
	end
	
	#Ajoute un clic aux statistiques du joueur
	def ajouterClic
	
		@profil.getStats["nombre_clics"] += 1
	end
	
	#Ajoute 1  ragequit aux statistiques du joueur
	def ajouterRageQuit
	
		@profil.getStats["ragequits"] += 1
	end
	
	def ajouterTemps(unTemps)
	
		@profil.getStats["temps_joue"] += unTemps
	end
end
