#encoding: UTF-8

require './Modeles/ModeleAccueil'

require './Vues/VueAccueil'
require './Vues/ListeurSauvegardes'
require './Vues/ListeurGrillesJouables'

require './Controleurs/Controleur'
require './Controleurs/ControleurEditeur'
require './Controleurs/ControleurProfil'
require './Controleurs/ControleurJeu'

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
		
		#On revient au menu quand la fenêtre de l'accueil est fermée
		@vue.window.signal_connect('delete_event'){
		
			@modele.sauvegarderProfil
			changerControleur(ControleurDemarrage.new(@picross))
		}
		
		#Retour à l'accueil
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
		}
	
		@vue.boutonProfil.signal_connect("clicked"){

			changerControleur(ControleurProfil.new(@picross, @modele.profil))
		}
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
	
	#Ouvre une boite de dialogue permettant au joueur de choisir entre charger une partie ou en créer une nouvelle
	def dgBoxChoixPartie
	
		dialogue = Gtk::Dialog.new("Choix de jeu", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Charger", 1], ["Nouvelle partie", 2])

		dialogue.set_modal(true)
		dialogue.show_all
		
		dialogue.run{|reponse|
			
			case reponse

				when 1#Chargement

					dgBoxChargement
					
				when 2#Nouvelle partie

					dgBoxNouvellePartie
			end
		}
		
		dialogue.destroy
	end
	
	#Propose au joueur l'ensemble de ses sauvegardes
	def dgBoxChargement
	
		dialogue = Gtk::Dialog.new("Chargement d'une sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Annuler", 1], ["Charger", 2])
		dialogue.set_modal(true)
		dialogue.set_size_request(600, 200)
		
		listeur = ListeurSauvegardes.new(@modele)
		dialogue.vbox.add(listeur)

		dialogue.show_all
		
		dialogue.run{|reponse|
				
			#Chargement
			if reponse == 2
		
				changerControleur(ControleurJeu.new(@picross, @modele.profil, true, listeur.treeView.selection.selected[0]))
			end
		}
		
		dialogue.destroy
	end
	
	#Propose au joueur l'ensemble des grilles jouables
	def dgBoxNouvellePartie
	
		dialogue = Gtk::Dialog.new("Ouverture d'une sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
		listeur = ListeurGrillesJouables.new(@modele)
		
		dialogue.set_size_request(600, 200)
		dialogue.set_modal(true)	
		dialogue.vbox.add(listeur)			
		dialogue.show_all
		
		dialogue.run{|reponse|

			#On ne traite la réponse que si l'utilisateur a cliqué sur "OPEN"
			if reponse == Gtk::Dialog::RESPONSE_ACCEPT then

				changerControleur(ControleurJeu.new(@picross, @modele.profil, false, listeur.treeView.selection.selected[0]))
			end
		}

		dialogue.destroy
	end
	
	def creerHBox(unTitre, unLabel)
	
		hBox = Gtk::HBox.new(true, 5)
		
		hBox.pack_start(Gtk::Label.new(unTitre + " : "))
		hBox.pack_start(unLabel)
		return hBox
	end
end
