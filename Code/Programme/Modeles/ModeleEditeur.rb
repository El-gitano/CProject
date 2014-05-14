# encoding: utf-8

require_relative 'ModeleGrille'
require_relative 'Grilles/GrilleEditeur'
require 'date'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < ModeleGrille
		
	public_class_method :new
	
	attr_reader :grille
	
	def initialize(unProfil, uneTaille)
	
		super(unProfil)
		@grille = GrilleEditeur.Creer(uneTaille, "NouvelleGrille", unProfil, 0)
	end
	
	#Retourne vrai si le profil chargé dans le modèle est propriétaire d'une grille dont le nom est passé en paramètre (et vrai si la grille n'existe pas)
	def grillePropriete(unNomGrille)
		
		return (!grilleExiste?(unNomGrille) or !requete("SELECT * FROM grilleediter WHERE createur = (SELECT id FROM profil WHERE pseudo='#{getPseudo}') AND nomgrille = '#{unNomGrille}'").empty?)
	end

	#Sauvegarde une grille éditeur sous le nom passé en paramètre
    def sauvegarderGrilleEditeur(nomGrille)
    
        serial = @grille.casesSerialize
        tailleGrille = @grille.taille
        nbJokers = @grille.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")

        self.requete("INSERT INTO grilleediter(createur,nomgrille,taillegrille,grille,nbjokers,datecreation,datemaj) VALUES((SELECT id FROM profil WHERE pseudo='#{getPseudo}'),'#{nomGrille}','#{tailleGrille}','#{serial}','#{nbJokers}','#{date}','#{date}')")
        
    end

	#Met à jour une grille à partir de son nom
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
