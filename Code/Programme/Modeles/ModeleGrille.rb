# encoding: utf-8 

require_relative 'Modele'
require_relative 'Grilles/GrilleEditeur'
require 'date'

#Le mod�le de l'�diteur permet de manipuler la grille � �diter ainsi que d'en sauvegarder/charger une
class ModeleGrille < Modele
	
	@grille
	
	attr_accessor :grille
	
	def initialize(unProfil)
	
		super(unProfil)
	end

	#Retourne vrai si une grille du nom pass� en param�tre existe
    def grilleExiste?(nom)
    
        grille = requete("SELECT COUNT(*) AS 'liste' FROM grilleediter WHERE nomgrille = '#{nom}'")
		return true if grille[0]["liste"] >= 1
    end
	
	#Charge une grille
    def charger(uneGrille)
    
        @grille = getGrille(uneGrille)
    end
	
	#Retourne une grille par son nom
	def getGrille(nomGrille)
	
        reqTemp = requete("SELECT * FROM grilleediter WHERE nomgrille='#{nomGrille}'")
        
        #G�n�ration de la grille r�sultat
		grille = GrilleEditeur.Creer(reqTemp[0]["taillegrille"], reqTemp[0]["nomgrille"], reqTemp[0]["createur"], reqTemp[0]["nbjokers"])
		grille.dateModification = reqTemp[0]["datemaj"]
		grille.dateCreation = reqTemp[0]["datecreation"]
		grille.cases = Grille.casesDeserialize(reqTemp[0]["grille"])
		grille.nbJokers = reqTemp[0]["nbjokers"]

		return grille
    end
	
	#Retourne une case de la grille du mod�le
	def getCase(x,y)
	
		return @grille.getCase(x,y)
    end
	
    def to_s
        print "\n",@grille.nomGrille," ",@grille.nbJokers," ",@grille.taille,"\n"
        @grille.to_debug
    end
	
end
