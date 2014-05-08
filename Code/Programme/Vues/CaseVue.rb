require 'gtk2'

class CaseVue < Gtk::EventBox

	@x
	@y
	
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
	
	#Change la variale interne etat de l'instance et change l'image pour celle de l'état nouveau (avec la taille de base)
	def changerEtat(unEtat)
	
		remove(@image) if not @image.nil?
		setImage(unEtat, @tailleGrille)
		add(@image)
		@etat = unEtat
		
		show_all	
	end
	
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
