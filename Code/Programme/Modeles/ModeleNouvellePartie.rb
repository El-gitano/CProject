#encoding UTF-8

require_relative 'Modele'

class ModeleNouvellePartie < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne l'ensemble des grilles sur lesquelles le joueur peut jouer
	def infosGrillesJouables
		
		req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur")
		return req
	end
end
