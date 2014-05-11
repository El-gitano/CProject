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
	@timer
	
	@informations#Informations numériques sur la grille de référence
	
	attr_reader :plateauJeu,:timer


	def initialize(unProfil)
	
		super(unProfil)
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
	
	def remplacerSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        idProfil = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{@grille.nomGrille}'") 
		req = "UPDATE grillejouee SET grille='#{serial}',jokersRestants='#{nbJokers}',timer='#{@timer}',datemaj='#{date}' WHERE joueur='#{idProfil[0]["id"]}' AND nompartie='#{nomPartie}' AND idGrille='#{idGrilleRef[0]["id"]}'"
		#print req
		self.requete(req)
	end
	
	def nouvelleSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        
		idProfil = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{@grille.nomGrille}'")
		self.requete("INSERT INTO grillejouee(joueur,idGrille,nompartie,grille,jokersRestants,timer,datedebut,datemaj) VALUES('#{idProfil[0]["id"]}','#{idGrilleRef[0]["id"]}','#{nomPartie}','#{serial}','#{nbJokers}','#{@timer}','#{date}','#{date}')")
	end
	
	def nouvellePartie(nomPartie,uneGrille)
		#TODO initialisation du timer
		@timer = 0
		
		#On récupère les infos de la grille passées en paramètre puis on instancie une GrilleEditeur
		@grille = charger(uneGrille)
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)
	
		@profil.donnees.stats["parties_commencees"]+=1
		sauvegarderProfil()
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)
		
	end
	
	def chargerPartie(nomPartie)
	
		idProfil = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		req = "SELECT * FROM grillejouee WHERE nompartie='#{nomPartie}' AND joueur='#{idProfil[0]["id"]}'"
		reqTemp = requete(req)
		
		
		nomGrilleRef = requete("SELECT nomgrille FROM grilleediter WHERE id='#{reqTemp[0]["idGrille"]}'")
		
		@grille = charger(nomGrilleRef[0]["nomgrille"])
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)
		
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)
		@plateauJeu.cases = Grille.casesDeserialize(reqTemp[0]["grille"])  
		@plateauJeu.nbJokers = reqTemp[0]["jokersRestants"]
		
		#TODO initialisation du timer
		@timer = 0
			
	end
		
		#Retourne un tableau des noms des sauvegardes d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def listeNomGrillesChargeables(unPseudo)
		id = requete("SELECT id FROM profil WHERE pseudo='#{unPseudo}'")
        reqGrille = requete("SELECT nompartie FROM grillejouer WHERE joueur='#{id[0]["id"]}'")
		res = Array.new
		i = 0
		
		reqGrille.each do |x|

				res.push(reqGrille[i]["nompartie"])
				yield reqGrille[i]["nompartie"]
				i+=1
				
		end
		
		return res
    end
	
	def to_s
		@grille.to_debug
		@plateauJeu.to_debug
		@informations.to_debug
		print grilleValide?
	end
	

end
