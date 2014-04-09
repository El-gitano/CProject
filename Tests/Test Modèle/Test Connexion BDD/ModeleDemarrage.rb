require './Modele'

class ModeleDemarrage < Modele
	
	def initialize
	
		super()		
		#ajouterObservateur(VueDemarrage.new(self))
	end
	
	def existe?(unLogin)

		
		res = requete "SELECT COUNT(*) AS 'cpt' FROM profil WHERE pseudo = '#{unLogin}'"
		return true if res[0]["cpt"] == 1 
		return false
	end
	
	def creerProfil(unLogin)
		
		if not existe?(unLogin) then
		
			requete("INSERT INTO profil(pseudo, pass) VALUES ('#{unLogin}', NULL)")
			return true
		
		else
		
			return false
		end
	end
	
	def listeProfils
	
		retour = Array.new
		
		res = requete "SELECT pseudo FROM profil"
		
		if not res.nil? then
		
			res.each{|x|
		
				retour.push(x["pseudo"])
			}	
		end
		
		return retour
	end
end
