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
	
		
	end
	
	#Retourne la liste des grilles par leurs noms
	def listeGrilles
	
	
	end
	
	def getTailleGrille(uneGrille)
	
		res = requete("SELECT taillegrille FROM grilleediter WHERE nomgrille = '#{uneGrille}'")
		
		return res[0]["taillegrille"]
	end
	
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
