#encoding UTF-8

require_relative 'Modele'

class ModeleChargerSauvegarde < Modele

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne les informations sur les sauvegardes d'un joueur
	def infosSauvegardes
	
        req = requete("SELECT nompartie, nomgrille, taillegrille, jokersRestants, grillejouee.datemaj FROM grillejouee INNER JOIN grilleediter ON grillejouee.idGrille=grilleediter.id WHERE joueur = #{@profil.getStats["id"]}")
		return req
	end
	
	#Supprime la sauvegarde du nom passé en paramètre
	def supprimerSauvegarde(unNom, uneGrille)
	
		requete("DELETE FROM grillejouee WHERE nompartie = '#{unNom}' AND joueur = #{@profil.getStats["id"]} AND idGrille = (SELECT id FROM grilleediter WHERE nomGrille = '#{uneGrille}')")
		lancerMaj
	end
end
