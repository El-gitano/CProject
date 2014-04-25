# encoding: UTF-8

require './Modeles/ModeleJeu'
require './Vues/VueJeu'
require './Controleurs/Controleur'

require 'gtk2'

class ControleurJeu < Controleur

	# Constructeur
	def initialize(unJeu, unModele)

		super(unJeu)

		@modele = ModeleJeu.new
		@vue = VueJeu.new(@modele)
		
		@modele.ajouterObservateur(@vue)
	end

	# Retour a l'accueil
	@vue.boutonRetourAccueil.signal_connect("clicked"){	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	}


	# Bouton pour vérifier si la grille est correctement remplie 
	@vue.boutonVerifierGrille.signal_connect("clicked"){

		if @modele.plateau.estRempli?
			dialogue = Gtk::Dialog.new("Fin de partie", @window, Gtk::Dialog::DESTROY_WITH_PARENT,["Nouvelle Partie", Gtk::Dialog::RESPONSE_ACCEPT],["Retour à l'accueil", Gtk::Dialog::RESPONSE_REJECT])
		
			# Creation des box
			hbox1 = Gtk::HBox.new(false, 5)	

			hbox2 = Gtk::HBox.new(false, 5)	
				vbox1 = Gtk::VBox.new(false, 5)
				vbox2 = Gtk::VBox.new(false, 5)

			# Creation des elements
			labelInfo = Gtk::Label.new("La grille est correcte ! \n")	
			labelClic = Gtk::Label.new("Nombre de clics : ")
			labelJoker = Gtk::Label.new("Nombre de jokers utilises : ")
			labelErreur = Gtk::Label.new("Nombre d'erreurs : ")
			labelTemps = Gtk::Label.new("Temps ecoule : ")

			labelNbClic = Gtk::Label.new("100")
			labelNbJoker = Gtk::Label.new("3")
			labelNbErreur = Gtk::Label.new("10")
			labelTempsEcoule = Gtk::Label.new("15:15 ")
		
			# Ajout des elements
			dialogue.vbox.add(hbox1)

			dialogue.vbox.add(hbox2)
				hbox2.add(vbox1)
				hbox2.add(vbox2)
				
			hbox1.add(labelInfo)

			vbox1.add(labelClic)
			vbox1.add(labelJoker)
			vbox1.add(labelErreur)
			vbox1.add(labelTemps)

			vbox2.add(labelNbClic)	
			vbox2.add(labelNbJoker)
			vbox2.add(labelNbErreur)		
			vbox2.add(labelTempsEcoule)

			# Affichage des elements et lancement de la fenetre
			dialogue.show_all

			dialogue.run{|reponse|
				
				if reponse == Gtk::Dialog::RESPONSE_ACCEPT then
					# Retour au menu de jeu
					changerControleur(ControleurMenuJeu.new(@picross, @modele.profil))

				else
					# Retour à l'accueil
					self.retourAccueil
				end			
			}

		else
			dialogue = Gtk::Dialog.new("Information", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
			labelInfo = Gtk::Label.new("La grille doit être remplie avant de pouvoir la vérifier.")

			dialogue.vbox.add(labelInfo)
			dialogue.show_all
			dialogue.run
		end
	}	


	# Recommencer la grille
	@vue.boutonRecommencer.signal_connect("clicked"){

		@modele.grille.reinitialiserCases
		@modele.plateauJeu.timer = 0	
	}


	# Sauvegarder la grille pour la continuer plus tard
	@vue.boutonSauvegarder.signal_connect("clicked"){	

	}


	# Gestion des clics dans la grille		
	@vue.boutonCase.signal_connect("clicked"){		
		# Si clic gauche
			# si EtatNeutre
				# devient EtatJoue

			# si EtatJoue
				# devient EtatNeutre

			# si EtatCroix
				# devient EtatJoue

		# Si clic droit
			# si EtatNeutre
				# devientCroix

			# si EtatJoue
				#devient EtatCroix

			# si EtatCroix
				# devient EtatNeutre
	}


	# Utilisation d'un joker
	@vue.boutonJoker.signal_connect("clicked"){
		# on donne l'astuce
			dialogue = Gtk::Dialog.new("Astuce", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
			labelAstuce = Gtk::Label.new("Astuce a modifier via un setLabel")

			dialogue.vbox.add(labelInfo)
			dialogue.show_all
			dialogue.run

		# on decremente le nb de jokers
		@modele.plateauJeu.enleverJoker
	}
end
