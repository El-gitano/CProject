# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleJeu'
require './Modeles/Grilles/GrilleEditeur'
require './Modeles/Grilles/InfosGrille.rb'
require 'date'

class ModeleJeu < ModeleGrille

	public_class_method :new
	
	@plateauJeu#Grille de jeu
	@grille#Grille de référence
	
	@informations#Informations numériques sur la grille de référence
	
	attr_reader :plateauJeu

	def initialize(unProfil, uneGrille, uneTaille)
	
		super(unProfil)
		
		#On récupère les infos de la grille passées en paramètre puis on instancie une GrilleEditeur
		@grille = charger(uneGrille)
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)
	end
	
	#retourne l'indice de @"grille" Dans ModeleGrille
	def getIndice
	end
	
	#compare grilleRef et grilleJeu, renvoie true si elles sont identiques
	def grilleValide?
	
		valide = @grille.cases == @plateauJeu.cases#Toujours faux car tu compares les adresses des objets et non leurs contenu ;)
		
		if valide then #Si grille terminée, +1 au nombre de partie terminées puis maj modification
			@profil.donnees.stats["parties_terminees"]+=1
			sauvegarderProfil()
		end
		
		return valide
	end
	
	def sauvegarderPartie(nomPartie)

		serial = @plateauJeu.casesSerialize
        tailleGrille = @plateauJeu.taille
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        
		id = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		#TODO verifier si nom existe : update si non : insert
		#self.requete("INSERT INTO grillejouer(joueur,nompartie,taillegrille,grille,jockersRestant,datecreation,datemaj) VALUES('#{id[0]["id"]}','#{nomGrille}','#{tailleGrille}','#{serial}','#{nbJokers}','#{date}','#{date}')")
	end
	
	def nouvellePartie(nomPartie)
		@profil.donnees.stats["parties_commencees"]+=1
		sauvegarderProfil()
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)
	end
	
	def chargerPartie(nomPartie)
	
	end
	
		#Retourne un tableau des noms des sauvegardes d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def listeNomGrillesChargeables(unPseudo)
	
		#TODO
    end
	
	def to_s
		@grille.to_debug
		@plateauJeu.to_debug
		@informations.to_debug
		print grilleValide?
	end
	

end
