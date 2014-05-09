require 'gtk2'

#Une case vue est un boite d'évènement qui contient une image
#À l'initialisation, on définit la taille de l'image contenue puis ensuite on la change seulement (le type de l'image mais pas la taille
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
			
				@image =  Gtk::Image.new("./Vues/Images/carreB"+@tailleGrille.to_s+".png")
				
			when "jouee"
			
				@image = Gtk::Image.new("./Vues/Images/carreN"+@tailleGrille.to_s+".png")
				
			when "croix"
				i=1
				#return Gtk::Image.new("./Vues/Images/carreN"+@tailleGrille.to_s+".png")
		end
	end
end
