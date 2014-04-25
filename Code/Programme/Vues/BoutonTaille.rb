class BoutonTaille < Gtk::Button

	@taille
	
	attr_reader :taille
	
	public_class_method :new
	
	def initialize(taille)
	
		super(taille.to_s + " X " + taille.to_s, false)
		@taille = taille
		
	end
	
end
