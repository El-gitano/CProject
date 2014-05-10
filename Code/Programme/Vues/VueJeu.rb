require './Vues/Vue'
require 'gtk2'

class VueJeu < Vue

	@miOuvrir
	@miSauvegarder
	@lbTimer
	@lbNomGrille
	@btJoker
	@btIndice
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)
		
		#VBox principale
		vbox = Gtk::VBox.new(false, 5)
		
		vbox.pack_start(creerMenu)
		vbox.pack_start(creerEntete)
		
		vbox.set_border_width(5)
		
		@window.add(vbox)
		@window.show_all
	end
	
	#Crée le menu en haut de la fenêtre de jeu
	def creerMenu
	
		mb = Gtk::MenuBar.new
		
		fichier = Gtk::MenuItem.new("Fichier")
		
		#On définit le menu fichier
		menuFichier = Gtk::Menu.new
		@miOuvrir = Gtk::MenuItem.new("Ouvrir")
		@miSauvegarder = Gtk::MenuItem.new("Sauvegarder")
		menuFichier.append(@miOuvrir)
		menuFichier.append(@miSauvegarder)
		
		fichier.set_submenu(menuFichier)
		
		mb.append(fichier)
		
		return mb
	end
	
	#Crée la tête de la fenêtre (Timer - NomGrille - HBoxAide)
	def creerEntete
	
		hbox = Gtk::HBox.new(false, 50)
		
		@lbTimer = Gtk::Label.new("Le Timer")
		@lbNomGrille = Gtk::Label.new("Le nom de la grille")
		hboxAide = creerVBoxAide
		
		hbox.pack_start(@lbTimer)
		hbox.pack_start(@lbNomGrille)
		hbox.pack_start(hboxAide)
		
	end
	
	#Crée une hBox contenant les boutons Joker et Indice
	def creerVBoxAide
	
		vbox = Gtk::VBox.new(false, 3)
		
		@btJoker = Gtk::Button.new
		@btIndice = Gtk::Button.new("Indice")
		
		vbox.pack_start(@btJoker)
		vbox.pack_start(@btIndice)
		
		return vbox
	end
	
	#Met à jour la vue à partir du modele
	def miseAJour
	
		
	end
	
		
end

Gtk.init
v = VueJeu.new("unModele")
Gtk.main
