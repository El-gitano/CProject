# encoding: utf-8

require_relative 'Controleur'
require_relative 'ControleurOuvrirGrille'

require_relative '../Modeles/ModeleEditeur'
require_relative '../Modeles/Grilles/GrilleEditeur'

require_relative '../Vues/VueEditeur'
require_relative '../Vues/Dialogues/DialogueInfo'
require_relative '../Vues/Dialogues/DialogueSaveEditeur'

require 'gtk2'

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
		
			uneCase.signal_connect("button_press_event"){

				@modele.getCase(uneCase.x,  uneCase.y).clicGauche
				@modele.lancerMaj
			}
		}

	end
	
	# Retour à l'accueil
	def retourAccueil
	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
