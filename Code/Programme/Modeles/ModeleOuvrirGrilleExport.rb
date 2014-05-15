#encoding: UTF-8

require_relative 'ModeleGrille'

#ModeleOuvrirGrille se charge d'afficher les grilles éditables par un joueur
class ModeleOuvrirGrilleExport < ModeleGrille

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne un tableau des informations sur les grilles appartenant à un utilisateur
	def infosGrillesEditables
	
        req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur WHERE pseudo='#{sanitize(@profil.pseudo)}'")
		return req
    end

end
