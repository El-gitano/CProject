require 'gtk2'

#Classe abstraite définissant les attributs et comportements généraux de nos vues concrètes
class Vue

	@modele
	@window
	
	attr_reader :window
	
	private_class_method :new
	
	#Une vue n'a besoin que d'un modèle pour fonctionner
	def initialize(unModele, leTitre)
	
		@modele = unModele
		
		@window = Gtk::Window.new(leTitre)
		@window.set_window_position(Gtk::Window::POS_CENTER)
		@window.set_resizable(false)
	end

	
	#A utiliser pour les test (pas besoin du modèle) ET À COMMENTER POUR LES AUTRES
	#def initialize()
	

	#	@window = Gtk::Window.new("Picross")
	#	@window.set_window_position(Gtk::Window::POS_CENTER)
	#	@window.set_resizable(true)
	#end
	
	
	#Actualiser sera redéfinit par les classes filles (on code ici pour débuguer)
	def actualiser
	
	
	end
	
	def fermerFenetre
	
		@window.hide_all
	end
end
