# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleEditeur'
require 'date'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < ModeleGrille
		
	public_class_method :new
	
	attr_reader :grille
	
	def initialize(unProfil, uneTaille)
	
		super(unProfil)
		@grille = GrilleEditeur.Creer(uneTaille, "NouvelleGrille", unProfil, 0)
	end
	
	#Retourne un tableau des noms des grilles d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def infosGrillesEditables
	
        req = requete("SELECT nomgrille, pseudo, taillegrille, nbjokers, datecreation, datemaj FROM grilleediter INNER JOIN profil ON profil.id = grilleediter.createur WHERE pseudo='#{@profil.pseudo}'")
		return req
    end
	
	#Retourne vrai si le profil chargé dans le modèle est propriétaire d'une grille dont le nom est passé en paramètre (et vrai si la grille n'existe pas)
	def grillePropriete(unNomGrille)
		
		return true if requete("SELECT * FROM grilleediter WHERE nomgrille = '#{unNomGrille}'").empty?
		
		id = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		
		return !requete("SELECT * FROM grilleediter WHERE createur = '#{id[0]["id"]}' AND nomgrille = '#{unNomGrille}'").empty?
	end
	
		#Sauvegarde une grille
    def sauvegarderGrille(nomGrille)
    
        serial = @grille.casesSerialize
        tailleGrille = @grille.taille
        nbJokers = @grille.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        
		id = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
        self.requete("INSERT INTO grilleediter(createur,nomgrille,taillegrille,grille,nbjokers,datecreation,datemaj) VALUES('#{id[0]["id"]}','#{nomGrille}','#{tailleGrille}','#{serial}','#{nbJokers}','#{date}','#{date}')")
        
    end

	#Met à jour une grille
	def miseAJourGrille(nomGrille)
	
		serial = @grille.casesSerialize
        tailleGrille = @grille.taille
        nbJokers = @grille.nbJokers
		dateModification = Time.now.strftime("%d/%m/%Y %H:%M")
		
		self.requete("UPDATE grilleediter SET taillegrille = '#{tailleGrille}', grille = '#{serial}', nbjokers = '#{nbJokers}', datemaj = '#{dateModification}' WHERE nomgrille = '#{nomGrille}'")
	end
	
	#Définit le nombre de jokers de la grille à l'aide de l'entier passé en paramètre
	def setNbJokers(uneValeur)
	
		@grille.nbJokers = uneValeur
	end
end
