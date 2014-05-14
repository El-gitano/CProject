#encoding: UTF-8

require_relative 'ModeleAvecProfil'

class ModeleAccueil < ModeleAvecProfil

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
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
