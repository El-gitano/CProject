# encoding: utf-8 

require_relative 'ModeleAvecProfil'
require_relative 'Grilles/GrilleEditeur'
require 'date'

#Modele grille contient l'ensemble des opérations communes aux autres modèles sur les grilles
class ModeleGrille < ModeleAvecProfil
	
	@grille
	public_class_method :new
	attr_accessor :grille
	
	def initialize(unProfil)
	
		super(unProfil)
	end

	#Retourne vrai si une grille du nom passé en paramètre existe
    def grilleExiste?(nom)
    
        return !requete("SELECT * FROM grilleediter WHERE nomgrille = '#{nom}'").empty?
    end
	
	#Charge une grille
    def charger(uneGrille)
    
        @grille = getGrille(uneGrille)
    end
	
	#Retourne une grille par son nom
	def getGrille(nomGrille)
	
        reqTemp = requete("SELECT * FROM grilleediter WHERE nomgrille='#{nomGrille}'")
        
        #Génération de la grille résultat
		grille = GrilleEditeur.Creer(reqTemp[0]["taillegrille"], reqTemp[0]["nomgrille"], reqTemp[0]["createur"], reqTemp[0]["nbjokers"])
		grille.dateModification = reqTemp[0]["datemaj"]
		grille.dateCreation = reqTemp[0]["datecreation"]
		grille.cases = Grille.casesDeserialize(reqTemp[0]["grille"])
		grille.nbJokers = reqTemp[0]["nbjokers"]

		return grille
    end
	
	#Retourne une case de la grille du modèle
	def getCase(x,y)
	
		return @grille.getCase(x,y)
    end
	
    def to_s
    
        print "\n",@grille.nomGrille," ",@grille.nbJokers," ",@grille.taille,"\n"
        @grille.to_debug
    end
	
end
