#encoding: UTF-8

require_relative 'ModeleAvecProfil'

# Ce modèle se contente de charger une partie précédemment commencée
class ModeleChargerSauvegarde < ModeleAvecProfil

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	#Retourne les informations sur les sauvegardes d'un joueur
	def infosSauvegardes
	
       return requete("SELECT nompartie, nomgrille, taillegrille, jokersRestants, grillejouee.datemaj FROM grillejouee INNER JOIN grilleediter ON grillejouee.idGrille=grilleediter.id WHERE joueur = #{@profil.getStats["id"]}")
	end
	
	#Supprime la sauvegarde du nom passé en paramètre
	def supprimerSauvegarde(unNom, uneGrille)
	
		requete("DELETE FROM grillejouee WHERE nompartie = '#{sanitize(unNom)}' AND joueur = #{@profil.getStats["id"]} AND idGrille = (SELECT id FROM grilleediter WHERE nomGrille = '#{sanitize(uneGrille)}')")
		lancerMaj
	end
end
