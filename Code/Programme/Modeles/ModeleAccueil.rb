#encoding UTF-8
require_relative 'Modele'

class ModeleAccueil < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne la taille d'une grille
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
