#encoding: UTF-8

require_relative 'ModeleGrille'

#ModeleOuvrirGrille se charge d'afficher les grilles éditables par un joueur
class ModeleOuvrirGrille < ModeleGrille

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne un tableau des informations sur les grilles appartenant à un utilisateur
	def infosGrillesEditables
	
        req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur WHERE profil.id ='#{@profil.getStats["id"]}'")
		return req
    end
	
	#Supprime la grille du nom passé en paramètre
	def supprimerGrille(uneGrille)
	
		requete("DELETE FROM grilleediter WHERE nomgrille = '#{sanitize(uneGrille)}'")
		lancerMaj
	end
end
