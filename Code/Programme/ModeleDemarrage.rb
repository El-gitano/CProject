require './Modele'

#Le modèle de démarrage permet au profil d'effectuer des intéraction avec la partie Profil de notre Bdd
class ModeleDemarrage < Modele
	
	public_class_method :new
	
	def initialize
	
		super()		
	end
	
	#Retourne vrai si unLogin existe, faux sinon
	def existe?(unLogin)

		
		res = requete "SELECT COUNT(*) AS 'cpt' FROM profil WHERE pseudo = '#{unLogin}'"
		return true if res[0]["cpt"] == 1 
		return false
	end
	
	#Crée un profil dans la base de donnée, retourne vrai en cas de succès, faux sinon
	def creerProfil(unLogin)
		
		if not existe?(unLogin) then
		
			requete("INSERT INTO profil(pseudo, pass) VALUES ('#{unLogin}', NULL)")
            tab=requete("SELECT id from profil WHERE pseudo = '#{unLogin}'")
            print requete("select * from profil")
            id = tab [0]["id"]
            req = "INSERT INTO stats(id, parties_commencees, parties_terminees, temps_joue, joker_utilises, indices_utilises, grilles_crees, ragequits) VALUES(#{id},0,0,0,0,0,0,0)"
            print "\n",req,"\n"
            requete(req)
            print requete("select * from stats"),"\n"

            return true
		else

            return false
		end
	end
	
	#Supprime unLogin de la base de donnée, retourne vrai en cas de succès, faux sinon
	def supprimerProfil(unLogin)
		
		if existe?(unLogin) then

            tab=requete("SELECT id from profil WHERE pseudo = '#{unLogin}'")
            id = tab [0]["id"]
			requete("DELETE FROM profil WHERE pseudo = '#{unLogin}'")
			requete("DELETE FROM stats WHERE id = '#{id}'")

			return true
		
		else
		
			return false
		end
	end
	
	#Retourne la liste des profils de la bdd ordonnés de manière alphabétique dans un tableau
	def listeProfils
	
		retour = Array.new
		
		res = requete "SELECT pseudo FROM profil ORDER BY pseudo ASC"
		
		if not res.nil? then
		
			res.each{|x|
		
				retour.push(x["pseudo"])
			}	
		end

		return retour
	end
end
