# encoding: UTF-8

require './Modeles/ModeleAccueil'
require './Vues/VueAccueil'
require './Controleurs/Controleur'
require './Controleurs/ControleurEditeur'
require './Controleurs/ControleurProfil'

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
		
		@vue.boutonDeco.signal_connect("clicked"){
	
			@modele.sauvegarderProfil
			changerControleur(ControleurDemarrage.new(@picross))
		}
	
		@vue.boutonJouer.signal_connect("clicked"){
	
			changerControleur(ControleurJeu.new(@picross, @modele.profil))
		}
	
		@vue.boutonEditer.signal_connect("clicked"){
	
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
	
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
end
