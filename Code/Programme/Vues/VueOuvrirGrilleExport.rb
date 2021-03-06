#encoding: UTF-8
require_relative 'Vue'
require_relative 'Listeurs/ListeurGrillesEditables'

require 'gtk2'

#Vue chargée de présenter une interface d'exportation de grille
class VueOuvrirGrilleExport < Vue

	@btRetour
	@btCharger
	@btSupprimer
	@listeur
	
	attr_reader :btRetour, :btCharger, :btSupprimer, :listeur
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Grille à exporter")
		@window.set_size_request(640, 200)
		
		@window.signal_connect("delete_event"){
		
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
		
		vbox = Gtk::VBox.new(false, 10)
		vbox.set_border_width(10)
		
		@listeur = ListeurGrillesEditables.new(@modele,true)
		
		hbox = Gtk::HBox.new(true, 5)
		
		@btRetour = Gtk::Button.new("Retour")
		@btCharger = Gtk::Button.new("Exporter")
		
		hbox.pack_start(@btRetour, false, true, 0)
		hbox.pack_start(@btCharger, false, true, 0)
		
		vbox.pack_start(@listeur)
		vbox.pack_start(hbox, false, false, 0)
		
		@window.add(vbox)
		@window.show_all
	end
	
	def miseAJour
	
		@listeur.maj
	end
end
