# encoding: utf-8

require './Modeles/Modele'
require './Modeles/Grilles/GrilleEditeur'
require 'date'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < Modele
	
	@grille
	
	attr_accessor :grille

	public_class_method :new
	
	def initialize(unProfil, uneTaille)
	
		super(unProfil)
		@grille = GrilleEditeur.Creer(uneTaille, "NouvelleGrille", unProfil, 0)
		#@grille.genererAleatoire
		#@grille.to_debug
		#lancerMaj
	end

	#Retourne vrai si une grille du nom passé en paramètre existe
    def grilleExiste?(nom)
    
        grille = requete("SELECT COUNT(*) AS 'liste' FROM grilleediter WHERE nomgrille = '#{nom}'")
		return true if grille[0]["liste"] >= 1
    end

	#Sauvegarde une grille
    def sauvegarderGrille(nomGrille)
    
        serial = @grille.casesSerialize
        tailleGrille = @grille.taille
        nbJokers = @grille.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        
        self.requete("INSERT INTO grilleediter(createur,nomgrille,taillegrille,grille,nbjokers,datecreation,datemaj) VALUES('#{@profil.pseudo}','#{nomGrille}','#{tailleGrille}','#{serial}','#{nbJokers}','#{date}','#{date}')")
        
    end

	#Met à jour une grille
	def miseAJourGrille(nomGrille)
	
		serial = @grille.casesSerialize
        tailleGrille = @grille.taille
		dateModification = Time.now.strftime("%d/%m/%Y %H:%M")
		
		self.requete("UPDATE grilleediter SET taillegrille = '#{tailleGrille}', grille = '#{serial}', nbjokers = '#{@nbJokers}', datemaj = '#{dateModification}' WHERE nomgrille = '#{nomGrille}'")
	end
	
	#Charge une grille
    def charger(uneGrille)
    
        @grille = getGrille(uneGrille)
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
	
	#Retourne une grille par son nom
	def getGrille(nomGrille)
	
        reqTemp = requete("SELECT * FROM grilleediter WHERE nomgrille='#{nomGrille}'")
        
        #Génération de la grille résultat
		grille = GrilleEditeur.Creer(reqTemp[0]["taillegrille"], reqTemp[0]["nomgrille"], reqTemp[0]["createur"], reqTemp[0]["nbjokers"])
		grille.dateModification = reqTemp[0]["datemaj"]
		grille.dateCreation = reqTemp[0]["datecreation"]
		grille.cases = Grille.casesDeserialize(reqTemp[0]["grille"])
        
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
