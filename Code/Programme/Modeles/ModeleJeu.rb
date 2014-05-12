# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleJeu'
require './Modeles/Grilles/GrilleEditeur'
require './Modeles/Grilles/InfosGrille.rb'
require './Modeles/Timer.rb'
require 'date'

class ModeleJeu < ModeleGrille

	public_class_method :new
	
	@plateauJeu#Grille de jeu
	@grille#Grille de référence
	@timer
	
	@informations#Informations numériques sur la grille de référence
	
	attr_reader :plateauJeu, :timer, :informations

	#Un choix à true désigne une sauvegarde à charger, à false une nouvelle partie, le nom correspond à la sauvegarde ou au nom de la grille
	def initialize(unProfil, unChoix, unNom)
	
		super(unProfil)
		
		if unChoix == true then
		
			chargerPartie(unNom)
		else
		
			nouvellePartie("Nouvelle partie", unNom)
		end
	end
	
	#retourne l'indice de @"grille" Dans ModeleGrille
	def getIndice
	end
	
	#Retourne vrai si la grille du joueur répond aux critères de la grille de solution
	def grilleValide?
	
		#Génération des indices de la grille de jeu
		informationsTemp = InfosGrille.new
		informationsTemp.genererInfos(@plateauJeu)
		
		#Comparaison des deux informations de grille
		valide =  (informationsTemp.infosLignes == @informations.infosLignes and  informationsTemp.infosColonnes == @informations.infosColonnes)
		
		if valide then #Si grille terminée, +1 au nombre de partie terminées puis maj modification
			@timer.stopperTimer
			@profil.donnees.stats["parties_terminees"]+=1
			sauvegarderProfil()
		end
		
		return valide
	end
	
	#Écrase la sauvegarde "nomPartie" avec des nouvelles données
	def remplacerSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        idProfil = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{@grille.nomGrille}'") 
		req = "UPDATE grillejouee SET grille='#{serial}', jokersRestants='#{nbJokers}', timer='#{@timer}', datemaj='#{date}' WHERE joueur='#{idProfil[0]["id"]}' AND nompartie='#{nomPartie}' AND idGrille='#{idGrilleRef[0]["id"]}'"
		#print req
		requete(req)
	end
	
	#Retourne vrai si le nom de sauvegarde passé en paramètre existe déjà pour un joueur
	def sauvegardeExiste(nomSauvegarde)
	
		return !requete("SELECT * FROM grillejouee WHERE nompartie = '#{nomSauvegarde}' AND createur = (SELECT id FROM profil WHERE pseudo = '#{@profil.pseudo}')").empty?
	end
	
	#Crée une nouvelle sauvegarde pour un joueur
	def nouvelleSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")
        
		idProfil = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{@grille.nomGrille}'")
		self.requete("INSERT INTO grillejouee(joueur,idGrille,nompartie,grille,jokersRestants,timer,datedebut,datemaj) VALUES('#{idProfil[0]["id"]}','#{idGrilleRef[0]["id"]}','#{nomPartie}','#{serial}','#{nbJokers}','#{@timer}','#{date}','#{date}')")
	end
	
	#Démarre une nouvelle partie
	def nouvellePartie(nomPartie, uneGrille)

		@timer = Timer.new
		
		#On récupère les infos de la grille passées en paramètre puis on instancie une GrilleEditeur
		@grille = charger(uneGrille)
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)

		@profil.donnees.stats["parties_commencees"]+=1
		sauvegarderProfil()
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)

		@timer.lancerTimer
		
	end
	
	#Charge une partie depuis son nom
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
		
		@timer = Timer.new(reqTemp[0]["timer"])
		@timer.lancerTimer
			
	end
		
	#Retourne un tableau des noms des sauvegardes d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def listeNomGrillesChargeables
	
		id = requete("SELECT id FROM profil WHERE pseudo='#{@profil.pseudo}'")
        reqGrille = requete("SELECT nompartie FROM grillejouer WHERE joueur='#{id[0]["id"]}'")
		res = Array.new
		i = 0
		
		reqGrille.each do |x|

			res.push(x["nompartie"])
			yield x["nompartie"]
			i+=1
				
		end
		
		return res
    end
	
	def ajouterRageQuit
	
		requete("UPDATE stats SET ragequits = ragequits+1 WHERE id = (SELECT id FROM profil WHERE pseudo = '#{@profil.pseudo}')")
	end
	
	def getCase(x,y)
	
		return @plateauJeu.getCase(x,y)
    end
    
	def to_s
		@grille.to_debug
		@plateauJeu.to_debug
		@informations.to_debug
		print grilleValide?
	end
end
