#encoding: UTF-8

require_relative '../Modeles/ModeleAccueil'

require_relative '../Vues/VueAccueil'
require_relative '../Vues/Listeurs/ListeurGrillesJouables'

require_relative 'Controleur'
require_relative 'ControleurEditeur'
require_relative 'ControleurProfil'
require_relative 'ControleurJeu'
require_relative 'ControleurChargerSauvegarde'
require_relative 'ControleurNouvellePartie'

require 'gtk2'

# Le contrôleur d'accueil permet d'accéder aux différents menu du jeu
class ControleurAccueil < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleAccueil.new(unProfil)
		@vue = VueAccueil.new(@modele)

		@modele.ajouterObservateur(@vue)	
		
		#On quitte quand on ferme la fenêtre
		@vue.window.signal_connect('delete_event'){
		
			quitterJeu
		}
		
		#Retour à la fenêtre de connexion
		@vue.boutonDeco.signal_connect("clicked"){
	
			@modele.sauvegarderProfil
			changerControleur(ControleurDemarrage.new(@picross))
		}
	
		#Lancement d'une partie (après sélection de la grille)
		@vue.boutonJouer.signal_connect("clicked"){
	
			dgBoxChoixPartie
		}
	
		#Lancement de l'éditeur
		@vue.boutonEditer.signal_connect("clicked"){
	
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
	
		#Affichage des crédits
		@vue.boutonCredit.signal_connect("clicked"){
		
			dgCredit
		}
	
		@vue.boutonProfil.signal_connect("clicked"){

			changerControleur(ControleurProfil.new(@picross, @modele.profil))
		}
	end
	
	#Ouvre une boite de dialogue permettant au joueur de choisir entre charger une partie ou en créer une nouvelle
	def dgBoxChoixPartie
	
		dialogue = Gtk::Dialog.new("Choix de jeu", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Retour", 0], ["Charger", 1], ["Nouvelle partie", 2])

		dialogue.set_modal(true)
		dialogue.show_all
		
		dialogue.run{|reponse|
			
			case reponse

				when 1#Chargement

					changerControleur(ControleurChargerSauvegarde.new(@picross, @modele.profil))
					
				when 2#Nouvelle partie

					changerControleur(ControleurNouvellePartie.new(@picross, @modele.profil))
			end
		}
		
		dialogue.destroy
	end
	
	#Ouvre une boîte de dialogue des crédits
	def dgCredit
	
		dialogue = Gtk::Dialog.new("Crédits", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		
		# Creation des elements
		tabNoms = Array.new

		tabNoms.push(hBoxNom("AYDIN Emre"))
		tabNoms.push(hBoxNom("FOUCAULT Antoine"))
		tabNoms.push(hBoxNom("GUENVER Loic"))
		tabNoms.push(hBoxNom("LANVIN Elyan"))
		tabNoms.push(hBoxNom("MARCAIS Thomas"))
		tabNoms.push(hBoxNom("RAMOLET Arthur"))

		labelAnnee = Gtk::Label.new("\nCrée en 2014")
		labelUniv = Gtk::Label.new("Projet Université du Maine")

		# Ajout des elements a la Vbox
		tabNoms.each{|x|

			dialogue.vbox.add(x)
		}

		dialogue.vbox.add(labelAnnee)
		dialogue.vbox.add(labelUniv)

		# Affichage des elements et lancement de la fenetre
		dialogue.show_all

		dialogue.run
		
		dialogue.destroy
	end
	
	#Crée une Hbox à partir d'un nom qu'elle entoure d'étoiles
	def hBoxNom(unNom)
	
		hBox = Gtk::HBox.new(false, 5)
		imEtoile = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		imEtoile2 = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		
		hBox.pack_start(imEtoile, false, false, 0)
		hBox.pack_start(Gtk::Label.new(unNom))
		hBox.pack_start(imEtoile2, false, false, 0)
		
		return hBox
	end
end
