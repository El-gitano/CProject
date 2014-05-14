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

		#Multi-sélection
		@vue.window.signal_connect("key-press-event"){|w, e|
		
			if  Gdk::Keyval::GDK_space == e.keyval then
			
				if @multiSelection then
				
					@multiSelection = false
					
				else
				
					@multiSelection = true
				end
			end
		}
		
		#On connecte un signal à chaque bouton
		@vue.table.each{|uneCase|
		
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
				
				@vue.actualiserCase(laCase.x, laCase.y)
			}
			
			uneCase.signal_connect("enter-notify-event"){|w, event|
			
				if @multiSelection then
				
					@modele.ajouterClic
					@modele.getCase(uneCase.x,  uneCase.y).clicGauche
					@modele.lancerMaj
				end
			}
		}
		
		#En cas de ragequit on met à jour le profil, on le sauvegarde et on quitte
		@vue.miRageQuit.signal_connect("activate"){
		
			@modele.ajouterRageQuit
			@modele.ajouterTemps
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
		
		#Affichage du didacticiel et arrete le Timer pendant ce temps et le reprendre lorsqu'on le ferme
		@vue.miDidac.signal_connect("activate"){
			
			@modele.timer.stopperTimer
			DialogueTuto.afficher(@vue.window)
			@modele.timer.lancerTimer
		}
		
		#Utilisation d'un joker
		@vue.btJoker.signal_connect("clicked"){
	
			#On dévoile les cases voulues
			@modele.utiliserJoker
		
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
		
		# Bouton pour vérifier si la grille est correctement remplie 
		@vue.btVerifier.signal_connect("clicked"){

			if @modele.grilleValide? then
				
				DialogueInfoFinPartie.afficher("Statistiques de fin de partie", @modele, @vue.window)

			else
				
				DialogueInfo.afficher("Grille invalide", "Votre grille est invalide", @vue.window)
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
		
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
	end
	
	#Propose au joueur de sauvegarder avant de revenir à l'accueil
	def sauvegardeQuitter
	
		if DialogueConfirmation.afficher("Proposition de sauvegarde", @vue.window, "Souhaitez vous sauvegarder votre partie avant de revenir à l'accueil ?") then
			
				DialogueSaveJeu.afficher()
		end
		
		@modele.timer.stopperTimer
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
