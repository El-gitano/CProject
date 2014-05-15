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
	
			#On trouve la ligne/colonne où on peut avoir un indice
			indice = @modele.getIndice
		
			if !indice.nil? then
		
				DialogueInfo.afficher("Indice", "Vous pouvez jouer #{indice}", @vue.window)
		
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
end
