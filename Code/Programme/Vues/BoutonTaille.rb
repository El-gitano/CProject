require 'gtk2'

#Un bouton taille redéfinit la taille de la grille de l'éditeur, il connait donc sa taille
class BoutonTaille < Gtk::Button

	@taille
	
	attr_reader :taille
	
	public_class_method :new
	
	def initialize(taille)
	
		#On inscrit la taille dans le bouton
		super(taille.to_s + " X " + taille.to_s, false)
		@taille = taille	
	end
end
