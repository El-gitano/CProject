require './Modeles/ModeleAvecProfil'

class ModeleAccueil < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	def getProfil
	
		return @profil.pseudo
	end
	
	#Retourne l'ensemble des sauvegardes sous cette forme : Nom_sauvegarde [Nom_grille] (date_modification)
	def listeSauvegardes
	
        reqGrille = requete("SELECT nompartie, nomgrille, grillejouee.datemaj FROM grillejouee JOIN grilleediter ON grillejouee.idGrille=grilleediter.id")

		res = Array.new

		reqGrille.each do |x|
		
				res.push("#{x["nompartie"]} [#{x["nomgrille"]}] (#{x["datemaj"]})")					
		end

		return res
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
