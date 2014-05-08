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
