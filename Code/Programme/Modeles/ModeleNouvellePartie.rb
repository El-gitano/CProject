#encoding: UTF-8

require_relative 'ModeleAvecProfil'

#ModeleNouvellePartie se contente de retourner l'ensemble des grilles sur lesquelles le joueur peut jouer
class ModeleNouvellePartie < ModeleAvecProfil

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
