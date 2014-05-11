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
        reqGrille = requete("SELECT nompartie,nomgrille,grillejouee.datemaj FROM grillejouee JOIN grilleediter ON grillejouee.idGrille=grilleediter.id")
		
		res = Array.new
		i = 0
		reqGrille.each do |x|
		
				res.push("#{reqGrille[i]["nompartie"]} [#{reqGrille[i]["nomgrille"]}] (#{reqGrille[i]["datemaj"]})")
				i+=1
				
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
	
		rep = requete("SELECT * FROM grilleediter WHERE nomgrille = '#{nomGrille}'")
		return rep[0]
	end
end
