require_relative 'Vue'
require_relative 'Listeurs/ListeurGrillesJouables'

require 'gtk2'

#Vue chargée de présenter une interface de selection de grille
class VueNouvellePartie < Vue

	@btRetour
	@btCharger
	@listeur
	
	attr_reader :btRetour, :btCharger, :listeur
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Nouvelle partie")
		@window.set_size_request(680, 350)
		
		vbox = Gtk::VBox.new(false, 10)
		vbox.set_border_width(10)
		
		@listeur = ListeurGrillesJouables.new(@modele)
		
		hbox = Gtk::HBox.new(true, 5)
		
		@btRetour = Gtk::Button.new("Retour")
		@btCharger = Gtk::Button.new("Charger")
		
		hbox.pack_start(@btRetour, false, true, 0)
		hbox.pack_start(@btCharger, false, true, 0)
		
		vbox.pack_start(@listeur)
		vbox.pack_start(hbox, false, false, 0)
		
		@window.add(vbox)
		@window.show_all
	end
end
