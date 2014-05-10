# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleEditeur'
require 'date'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < ModeleGrille
		
	def initialize(unProfil, uneTaille)
	
		super(unProfil,uneTaille)
	end
	
	#Retourne un tableau des noms des grilles d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def listeNomGrillesEditables(unPseudo)
	
        reqGrille = requete("SELECT nomgrille FROM grilleediter WHERE createur='#{unPseudo}'")
		res = Array.new
		i = 0
		
		reqGrille.each do |x|

				res.push(reqGrille[i]["nomgrille"])
				yield reqGrille[i]["nomgrille"]
				i+=1
				
		end
		
		return res
    end
	
	#Retourne vrai si le profil chargé dans le modèle est propriétaire d'une grille dont le nom est passé en paramètre (et vrai si la grille n'existe pas)
	def grillePropriete(unNomGrille)
		
		return true if requete("SELECT * FROM grilleediter WHERE nomgrille = '#{unNomGrille}'").empty?
		
		return !requete("SELECT * FROM grilleediter WHERE createur = '#{@profil.pseudo}' AND nomgrille = '#{unNomGrille}'").empty?
	end
	
end
