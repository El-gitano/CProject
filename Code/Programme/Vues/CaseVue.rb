require 'gtk2'

#Une case vue est un boite d'évènement qui contient une image
#À l'initialisation, on définit la taille de l'image contenue puis ensuite on change seulement l'image (mais pas sa taille)
class CaseVue < Gtk::EventBox

	@x
	@y
	
	#Permet d'effectuer la sélection de l'image à partir de son nom
	@tailleGrille
	
	@image
	@etat
	
	attr_reader :x, :y, :etat, :taille
	
	def initialize(unEtat, uneTaille, x, y)
	
		super()
		
		@tailleGrille = uneTaille
		@etat = unEtat
		@x = x
		@y = y
		
		changerEtat(unEtat)	
		show_all	
	end
	
	#Change la variable interne "etat" de l'instance et change l'image pour celle de l'état nouveau (avec la taille de base)
	def changerEtat(unEtat)
	
		remove(@image) if not @image.nil?
		setImage(unEtat, @tailleGrille)
		add(@image)
		@etat = unEtat
		
		show_all	
	end
	
	#Met à variable @image à une GtkImage de l'état et la taille désirée
	def setImage(unEtat, uneTaille)
	
		case unEtat
		
			when "neutre"
			
				@image =  Gtk::Image.new(File.expand_path("./Images/carreB"+@tailleGrille.to_s+".png", File.dirname(__FILE__)))
				
			when "jouee"
			
				@image = Gtk::Image.new(File.expand_path("./Images/carreN"+@tailleGrille.to_s+".png", File.dirname(__FILE__)))
				
			when "croix"

				@image = Gtk::Image.new(File.expand_path("./Images/croixPlateau"+@tailleGrille.to_s+".png", File.dirname(__FILE__)))
		end
	end
end
