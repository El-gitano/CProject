# encoding: utf-8

require_relative 'Controleur'
require_relative 'ControleurOuvrirGrille'
require_relative 'ControleurOuvrirGrilleExport'
require_relative 'ControleurOuvrirGrilleImport'

require_relative '../Modeles/ModeleEditeur'
require_relative '../Modeles/Grilles/GrilleEditeur'

require_relative '../Vues/VueEditeur'
require_relative '../Vues/Dialogues/DialogueInfo'
require_relative '../Vues/Dialogues/DialogueSaveEditeur'

require 'gtk2'

# Le contrôleur éditeur permet de créer ses propres grilles, de les exporter ou encore d'importer d'autres grilles
class ControleurEditeur < Controleur

	public_class_method :new
	
	@multiSelection = false
	
	# Constructeur
	def initialize(unJeu, unProfil, grilleACharger = nil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil, 10)
		@vue = VueEditeur.new(@modele)
		@modele.ajouterObservateur(@vue)	
		@modele.charger(grilleACharger) if !grilleACharger.nil?
		
		#On revient au menu quand la fenêtre de l'éditeur est fermée
		@vue.window.signal_connect('delete_event'){
		
			quitterJeu
		}
		
		#Boîte de dialogue pour ouverture d'une grille
		@vue.boutonOuvrir.signal_connect("clicked"){

			changerControleur(ControleurOuvrirGrille.new(@picross, @modele.profil))
		}
	
		#Dialogue pour l'enregistrement d'une grille
		@vue.boutonEnregistrer.signal_connect("clicked"){
	
			DialogueSaveEditeur.afficher(@vue.window, @modele)
			@modele.lancerMaj
		}
	
		#Génération d'un grille aléatoire
		@vue.boutonAleatoire.signal_connect("clicked"){
	
			@modele.grille.genererAleatoire
			@modele.lancerMaj
		}
		
		#Importer grille
		@vue.boutonImporter.signal_connect("clicked"){
	
			changerControleur(ControleurOuvrirGrilleImport.new(@picross, @modele.profil))
		}
		
		#Exporter grille
		@vue.boutonExporter.signal_connect("clicked"){
	
			changerControleur(ControleurOuvrirGrilleExport.new(@picross, @modele.profil))
		}

		# Bouton pour le retour a l'accueil	
		@vue.boutonRetour.signal_connect("clicked"){
			retourAccueil
		}

		#Le SpinButton des jokers
		@vue.sbNbJokers.signal_connect("value-changed"){
		
			@modele.setNbJokers(@vue.sbNbJokers.value)
		}
		
		#Changement de la taille de la grille
		@vue.listBoutonTaille.each{|x|
		
			x.signal_connect("clicked"){|leBouton|

				@modele.grille = GrilleEditeur.Creer(leBouton.taille, "NouvelleGrille", @modele.profil, 0)
				@modele.lancerMaj
				connecterGrille
			}
		}
		
		connecterGrille
		@modele.lancerMaj	
	end
	
	#Connecte un listener d'évènement sur chaque case de la grille pour récupérer les clics
	def connecterGrille
	
		#On connecte un signal pour chaque case du plateau
		@vue.operationGrille{|uneCase|

			#Changement d'état lors d'un clic
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				#On relâche le clic
				Gdk::Display.default.pointer_ungrab(Gdk::Event::CURRENT_TIME)
				
				# Si clic gauche
				if (event.button == 1) then
	
					@modele.getCase(laCase.x, laCase.y).clicGauche
	
				end
				
				@vue.actualiserCase(laCase.x, laCase.y)	
			}
			
			#Lors du passage de la souris on vérifie qu'on a pas un bouton de la souris appuyé
			uneCase.signal_connect("enter-notify-event"){|laCase, event|
				
				if event.state == Gdk::Window::BUTTON1_MASK
				
					@modele.getCase(laCase.x, laCase.y).clicGauche
					@vue.actualiserCase(laCase.x, laCase.y)
				end
			}
		}

	end
	
	# Retour à l'accueil
	def retourAccueil
	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
