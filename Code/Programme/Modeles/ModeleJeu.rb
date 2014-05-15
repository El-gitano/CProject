# encoding: utf-8

require_relative 'ModeleGrille'
require_relative 'Grilles/GrilleJeu'
require_relative 'Grilles/GrilleEditeur'
require_relative 'Grilles/InfosGrille'
require_relative 'Grilles/EtatsCases/EtatCaseCroix'
require_relative 'Grilles/EtatsCases/EtatCaseJouee'
require_relative 'Timer'
require 'date'

class ModeleJeu < ModeleGrille

	public_class_method :new
	
	@plateauJeu#Grille de jeu
	@grille#Grille de référence (solution)
	@timer
	
	@informations#Informations numériques sur la grille de référence
	
	attr_reader :plateauJeu, :timer, :informations

	#Un choix à true désigne une sauvegarde à charger, à false une nouvelle partie, le nom correspond à la sauvegarde ou au nom de la grille
	def initialize(unProfil, unChoix, unNom)
	
		super(unProfil)
		
		if unChoix == true then
		
			chargerPartie(unNom)
		else
		
			nouvellePartie(unNom, unNom)
		end
	end
	
	#Retourne un indice de jeu au joueur
	def getIndice
	
		ajouterIndice
		print "À implémenter"
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
			@profil.getStats["parties_terminees"] += 1
			sauvegarderProfil
		end
		
		return valide
	end
	
	#Écrase la sauvegarde "nomPartie" avec des nouvelles données
	def remplacerSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")

		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{sanitize(@grille.nomGrille)}'") 
		req = "UPDATE grillejouee SET grille='#{serial}', jokersRestants='#{nbJokers}', timer='#{@timer.temps}', datemaj='#{date}' WHERE joueur='#{@profil.getStats["id"]}' AND nompartie='#{sanitize(nomPartie)}' AND idGrille='#{idGrilleRef[0]["id"]}'"

		requete(req)
	end
	
	#Retourne vrai si le nom de sauvegarde passé en paramètre existe déjà pour un joueur
	def sauvegardeExiste?(nomSauvegarde)
	
		return !requete("SELECT * FROM grillejouee WHERE nompartie = '#{sanitize(nomSauvegarde)}' AND joueur = #{@profil.getStats["id"]}").empty?
	end
	
	#Crée une nouvelle sauvegarde pour un joueur
	def nouvelleSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")

		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{sanitize(@grille.nomGrille)}'")[0]["id"]
		requete("INSERT INTO grillejouee(joueur, idGrille, nompartie, grille, jokersRestants, timer, datedebut, datemaj) VALUES('#{@profil.getStats["id"]}','#{idGrilleRef}','#{sanitize(nomPartie)}','#{serial}','#{nbJokers}','#{@timer.temps}','#{date}','#{date}')")
		
	end
	
	#Démarre une nouvelle partie
	def nouvellePartie(nomPartie, uneGrille)

		@timer = Timer.new(0,@profil)
		
		#On récupère les infos de la grille passées en paramètre puis on instancie une GrilleEditeur
		charger(uneGrille)
		
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)

		@profil.getStats["parties_commencees"] += 1
		
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)

		lancerMaj
		@timer.lancerTimer	
	end
	
	#Charge une partie depuis son nom
	def chargerPartie(nomPartie)

		reqTemp = requete("SELECT * FROM grillejouee WHERE nompartie='#{sanitize(nomPartie)}' AND joueur='#{@profil.getStats["id"]}'")
		nomGrilleRef = requete("SELECT nomgrille FROM grilleediter WHERE id='#{reqTemp[0]["idGrille"]}'")
		
		@grille = charger(nomGrilleRef[0]["nomgrille"])
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)
		
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)
		@plateauJeu.cases = Grille.casesDeserialize(reqTemp[0]["grille"])  
		@plateauJeu.nbJokers = reqTemp[0]["jokersRestants"]
		
		@timer = Timer.new(reqTemp[0]["timer"], @profil)
		@timer.lancerTimer			
	end
	
	#Remet toutes les cases à l'état croix de la grille à l'état neutre
	def enleverCroix
	
		@plateauJeu.operationGrille{|uneCase|
		
			if uneCase.croix? then
			
				uneCase.changerEtat(EtatCaseNeutre.getInstance)
			end
		}
	end
		
	#Retourne un tableau des noms des sauvegardes d'un utilisateur, possibilité d'effectuer un traitement de type yield
	def listeNomGrillesChargeables
	
        reqGrille = requete("SELECT nompartie FROM grillejouer WHERE joueur='#{@profil.getStats["id"]}'")
		res = Array.new
		i = 0
		
		reqGrille.each do |x|

			res.push(x["nompartie"])
			yield x["nompartie"]
			i+=1
				
		end
		
		return res
    end
	
	#Ajoute le temps passé depuis le lancement de la grille au temps de jeu global du joueur
	def ajouterTemps
	
		super.ajouterTemps(@timer.tempsEcoule)
	end
	
	#Dévoile une case aléatoirement dans le jeu
	def utiliserJoker
	
		#On récupère les cases qui diffèrent de la solution dans le jeu
		casesFausses = Array.new
		
		0.upto((@plateauJeu.taille-1)){|x|
		
			0.upto((@plateauJeu.taille-1)){|y|
			
				casesFausses.push([@plateauJeu.getCase(x, y), x, y]) if (@plateauJeu.getCase(x, y).etat != @grille.getCase(x, y).etat)
			}
		}

		indice = Random.rand(casesFausses.size)
		
		caseAChanger = casesFausses[indice][0]
		x = casesFausses[indice][1]
		y = casesFausses[indice][2]
		
		#On met la solution
		caseSolution = @grille.getCase(x, y)
		
		if caseSolution.neutre? then
			
			caseAChanger.changerEtat(EtatCaseCroix.getInstance)
		
		elsif caseSolution.jouee? then
		
			caseAChanger.changerEtat(EtatCaseJouee.getInstance)
		end
				
		enleverJoker
	end
	
	#Retourne un tableau contenant les cases jouables par le joueur lors de l'appel
	def casesJouablesGrille
	
		cases = Array.new
		
		#On recherche des cases jouables pour chaque colonne
		0.upto(@plateauJeu.taille){|x|
		
			@plateauJeu.getColonne(x){
			
				
			}
		}
		
		#On recherche des cases jouables pour chaque ligne
		0.upto(@plateauJeu.taille){|y|

			casesJouablesLigne(@plateauJeu.getLigne(y))
		}
	end
	
	#Enlève un joker pour le joueur
	def enleverJoker
	
		@plateauJeu.nbJokers -= 1
		ajouterJoker
	end
	
	#Retourne une case de la grille de jeu
	def getCase(x,y)
	
		return @plateauJeu.getCase(x,y)
    end
    	
    #Retourne une tableau contenant les coordonnées des cases résolvables par le joueur au moment de l'appel
    def chercherSolutions
    
    	
    end
    
	def to_s
		@grille.to_debug
		@plateauJeu.to_debug
		@informations.to_debug
		print grilleValide?
	end
end
