#encoding UTF-8

require_relative 'Modele'

class ModeleOuvrirGrille < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne un tableau des informations sur les grilles appartenant à un utilisateur
	def infosGrillesEditables
	
        req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur WHERE pseudo='#{@profil.pseudo}'")
		return req
    end
	
	#Supprime la sauvegarde du nom passé en paramètre
	def supprimerGrille(uneGrille)
	
		requete("DELETE FROM grilleediter WHERE nomgrille = '#{uneGrille}'")
		lancerMaj
	end
end
