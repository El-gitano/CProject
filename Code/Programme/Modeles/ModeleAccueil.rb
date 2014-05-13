require './Modeles/ModeleAvecProfil'

class ModeleAccueil < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne les informations sur les sauvegardes d'un joueur
	def infosSauvegardes
	
        req = requete("SELECT nompartie, nomgrille, taillegrille, jokersRestants, grillejouee.datemaj FROM grillejouee INNER JOIN grilleediter ON grillejouee.idGrille=grilleediter.id WHERE joueur = (SELECT id FROM profil WHERE pseudo = '#{@profil.pseudo}')")

		return req
	end
	
	def infosGrillesJouables
		
		req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur")
		return req
	end
	
	def getTailleGrille(uneGrille)
	
		res = requete("SELECT taillegrille FROM grilleediter WHERE nomgrille = '#{uneGrille}'")
		
		return res[0]["taillegrille"]
	end
	
	#Retourne la liste des grilles par leurs noms
	def listeGrilles
	
		res = Array.new
		rep = requete("SELECT nomgrille FROM grilleediter")
		
		rep.each{|x|
		
			res.push(x["nomgrille"])
		}
		
		return res
	end
	
	def getInfosGrille(nomGrille)
	
		rep = requete("SELECT profil.pseudo as createur, nbjokers, taillegrille, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur WHERE nomgrille = '#{nomGrille}'")
		return rep[0]
	end
end
