# encoding: UTF-8

require './Modeles/ModeleAccueil'
require './Vues/VueAccueil'
require './Controleurs/Controleur'

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
		
			dialogue = Gtk::Dialog.new("Credits", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		
			# Creation des elements
			tabNoms = Array.new

			tabNoms.push(Gtk::Label.new("AYDIN Emre"))
			tabNoms.push(Gtk::Label.new("FOUCAULT Antoine"))
			tabNoms.push(Gtk::Label.new("GUENVER Loic"))
			tabNoms.push(Gtk::Label.new("LANVIN Elyan"))
			tabNoms.push(Gtk::Label.new("MARCAIS Thomas"))
			tabNoms.push(Gtk::Label.new("RAMOLET Arthur"))

			labelAnnee = Gtk::Label.new("Crée en 2014")
			labelUniv = Gtk::Label.new("Projet Université du Maine")

			boutonOK = Gtk::Button.new("Ok", false)

			# Ajout des elements a la Vbox
			tabNoms.each{|x|

				dialogue.vbox.add(x)
			}

			dialogue.vbox.add(labelAnnee)
			dialogue.vbox.add(labeluniv)

			# Affichage des elements et lancement de la fenetre
			dialogue.show_all

			dialogue.run
		}
	
		@vue.boutonProfil.signal_connect("clicked"){

			changerControleur(ControleurProfil.new(@picross, @modele.profil))
		}
	end
end
