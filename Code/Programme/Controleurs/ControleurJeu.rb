#encoding: UTF-8

require_relative '../Modeles/ModeleJeu'
require_relative '../Vues/VueJeu'

require_relative '../Vues/Dialogues/DialogueTuto'
require_relative '../Vues/Dialogues/DialogueInfoFinPartie'
require_relative '../Vues/Dialogues/DialogueSaveJeu'
require_relative '../Vues/Dialogues/DialogueConfirmation'

require_relative 'Controleur'

require 'gtk2'

#Le contrôleur de jeu définit l'ensemble de la logique du jeu de Picross
class ControleurJeu < Controleur

	@multiSelection
	
	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil, unChoix, unNom)

		super(unJeu)

		@modele = ModeleJeu.new(unProfil, unChoix, unNom)
		@vue = VueJeu.new(@modele)	
		@modele.ajouterObservateur(@vue)
		
		#On link le label au timer
		@modele.timer.label = @vue.lbTimer
		
		#On connecte un signal à chaque bouton
		@vue.table.each{|uneCase|
		
			#Changement d'état lors d'un clic
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				#Màj stats
				@modele.ajouterClic
				
				# Si clic gauche
				if (event.button == 1) then
	
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicGauche
					
				# Si clic droit
				elsif (event.button == 3) then
		
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicDroit		
				end
				
				lancerVerification
				@vue.actualiserCase(laCase.x, laCase.y)	
			}
		}
		
		#En cas de ragequit on met à jour le profil, on le sauvegarde et on quitte
		@vue.miRageQuit.signal_connect("button_press_event"){
		
			@modele.ajouterRageQuit
			quitterJeu
		}
		
		#Affichage du didacticiel et arrete le Timer pendant ce temps et le reprendre lorsqu'on le ferme
		@vue.miDidac.signal_connect("button_press_event"){
			
			@modele.timer.stopperTimer
			DialogueTuto.afficher(@vue.window)
			@modele.timer.lancerTimer
		}
		
		#Utilisation d'un joker
		@vue.btJoker.signal_connect("clicked"){
	
			#On dévoile les cases voulues
			@modele.utiliserJoker
			
			#On vérifie que ça n'a pas résolu la grille
			lancerVerification
			
			#On met jour la/les vues
			@modele.lancerMaj
		}
	
		#Utilisation d'un indice
		@vue.btIndice.signal_connect("clicked"){
	
			erreursTrop = @modele.chercherErreursTrop
			erreursBlocs = @modele.chercherErreursBlocs
			casesJouables = @modele.getIndice
			
			#Si il y a des erreurs de type trop de cases dans la grille
			if !erreursTrop.nil? then
			
				lVSc = determinerIndice(erreursTrop)
				indice = Random.rand(erreursTrop[lVSc].size)
				element = lVSc.eql?(1) ? "colonne" : "ligne"
				
				DialogueInfo.afficher("Mauvais jeu", "Vous devriez commencer par vérifier les cases #{element} #{erreursTrop[lVSc][indice]+1}...", @vue.window)
			
			#Si le joueur a des blocs consécutifs qui ne respectent pas les infos
			elsif !erreursBlocs.nil?
			
				lVSc = determinerIndice(erreursBlocs)
				print lVSc
				indice = Random.rand(erreursBlocs[lVSc].size)
				element = lVSc.eql?(1) ? "colonne" : "ligne"
				
				DialogueInfo.afficher("Mauvais jeu", "Vous devriez commencer par vérifier vos/votre bloc(s) #{element} #{erreursBlocs[lVSc][indice]+1}...", @vue.window)
				
			#Il y a un indice à donner	
			elsif !casesJouables.nil?
			
				casesJouables.each{|c|
				
					c.changerEtat(EtatCaseJouee.getInstance)
					@vue.actualiserCase(c.x, c.y)
				}
				
			#Il n'y a pas d'indices à donner
			else
			
				DialogueInfo.afficher("Indice introuvable", "Nous n'avons aucun indice à vous donner", @vue.window)
			end
		}

		# Sauvegarder la grille pour la continuer plus tard
		@vue.miSauvegarder.signal_connect("activate"){
		
			@modele.timer.stopperTimer
			DialogueSaveJeu.afficher(@vue.window, @modele)
			@modele.lancerMaj
			@modele.timer.lancerTimer
		}
		
		# On propose la sauvegarde avant de quitter la partie
		@vue.miQuitter.signal_connect("activate"){
		
			@modele.timer.stopperTimer
			sauvegardeQuitter
		}
		
		#On quitte le jeu
		@vue.window.signal_connect('delete_event'){
		
			quitterJeu
		}
	end
	
	#Vérifie si la grille est résolue et agit en conséquence si c'est le cas
	def lancerVerification
	
		if @modele.grilleValide? then
				
			@modele.enleverCroix
			@modele.lancerMaj
			DialogueInfoFinPartie.afficher("Statistiques de fin de partie", @modele, self, @vue.window)
		end
	end
	
	#Propose au joueur de sauvegarder avant de revenir à l'accueil
	def sauvegardeQuitter
	
		if DialogueConfirmation.afficher("Proposition de sauvegarde", @vue.window, "Souhaitez vous sauvegarder votre partie avant de revenir à l'accueil ?") then
			
				DialogueSaveJeu.afficher(@vue.window, @modele)
		end
		
		@modele.timer.stopperTimer
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
	
	#Prends en paramètre un tableau contenant deux tableaux
	#Si l'un des deux tableau est vide, la méthode renvoi l'indice du tableau plein sinon elle renvoi aléatoirement 0 ou 1
	def determinerIndice(unTab)
	
		#Seulement erreur de lignes
		if !unTab[0].empty? and unTab[1].empty? then
		
			return 0
			
		#Seulement erreur de colonnes
		elsif unTab[0].empty? and !unTab[1].empty? then
		
			return 1
			
		#Les deux
		else
		
			return Random.rand(2)
		end
	end
end
