require 'gtk2'

#Classe abstraite définissant les attributs et comportements généraux de nos vues concrètes
class Vue

	@modele
	@window
	
	attr_reader :window
	
	private_class_method :new
	
	#Une vue n'a besoin que d'un modèle pour fonctionner
	def initialize(unModele)
	
		@modele = unModele
		
		@window = Gtk::Window.new("Picross accueil")
		@window.set_window_position(Gtk::Window::POS_CENTER)
		@window.set_resizable(false)
	end
	
	#Actualiser sera redéfinit par les classes filles (on code ici pour débuguer)
	def actualiser
	
	
	end
end
