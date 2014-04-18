# encoding: utf-8

require './Modeles/Grilles/GrilleEditeur'
require 'gtk2'

class ControleurEditeur < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil)
		@vue = VueDemarrage.new(@modele)
		
		@modele.ajouterObservateur(@vue)
		
		@vue.boutonOuvrir.signal_connect("clicked"){
		
			dialogue = Gtk::Dialog.new("Ouverture d'une grille", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_REJECT])
			dialogue.set_modal(true)
			
			list_store = Gtk::ListStore.new(String)		
			comboBoxGrilles = Gtk::ComboBox.new(@list_store, 0)
		
			#Charger le list store
			laGrille = nil
		
			ligneH = Gtk::HSeparator.new
		
			nomGrille = Gtk::Label.new("Le nom de la grille")
		
			hBox = Gtk::HBox.new(false, 5)
		
			#Création de l'intérieur de la boite de dialogue
			lbNbJoker = Gtk::Label.new("Nombre de Jokers : ")
			lbTaille = Gtk::Label.new("Taille de la grille : ")
			lbDateCreation = Gtk::Label.new("Date de création de la grille : ")
		
			hBox.pack_start(lbNbJoker, false, false, 0)
			hBox.pack_start(lbTaille, false, false, 0)
			hBox.pack_start(lbDateCreation, false, false, 0)
		
			#Ajout à la vbox par défaut
			dialogue.vbox.pack_start(comboBoxGrilles, false, false, 0)
			dialogue.vbox.pack_start(nomGrille, false, false, 0)
			dialogue.vbox.pack_start(hBox, false, false, 0)
	
			dialogue.show_all
	
			dialogue.run{|reponse|
		
				#On ne traite la réponse que si l'utilisateur a cliqué sur "OPEN"
				case response
				
	   				when Gtk::Dialog::RESPONSE_ACCEPT
	   				
	   					@modele.ouvrirGrille(laGrille)
	   			end
			}
	
			dialogue.destroy
			
			@modele.lancerMaj
		}
	
		@vue.boutonEnregistrer.signal_connect("clicked"){
	
			if @modele.enregistrerGrille then
		
				dialogue = Gtk::Dialog.new("Sauvegarde de la grille", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT)
				hbox = Gtk::HBox.new(false, 5)
			
				label = Gtk::Label.new("Grille sauvegardée avec succès")
				image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
	
				hbox.pack_start(image, false, false, 0)
				hbox.pack_start(label, false, false, 0)
	
				dialogue.vbox.add(hbox)
	
				dialogue.show_all	
				dialogue.run
			
				dialogue.destroy
		
			else
		
				print "Erreur dans la sauvegarde de la grille"
				exit(-1)
			end
		}
	
		@vue.boutonAleatoire.signal_connect("clicked"){
	
			@modele.grille.genererAleatoire
			@modele.lancerMaj
		}
	
		@vue.bouton5.signal_connect("clicked"){

			@modele.grille = GrilleEditeur.creerGrille(5)
			@modele.lancerMaj
		}
	
		@vue.bouton10.signal_connect("clicked"){
		
			@modele.grille = GrilleEditeur.creerGrille(10)
			@modele.lancerMaj	
		}
	
		@vue.bouton15.signal_connect("clicked"){
		
			@modele.grille = GrilleEditeur.creerGrille(15)
			@modele.lancerMaj	
		}
	
		@vue.bouton20.signal_connect("clicked"){
		
			@modele.grille = GrilleEditeur.creerGrille(20)
			@modele.lancerMaj	
		}
	
		@vue.bouton25.signal_connect("clicked"){
		
			@modele.grille = GrilleEditeur.creerGrille(25)
			@modele.lancerMaj	
		}
	end
	
	# Retour a l'accueil
	def retourAccueil
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
