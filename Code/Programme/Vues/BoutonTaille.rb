class BoutonTaille < Gtk::Button

	@taille
	
	attr_reader :taille
	
	public_class_method :new
	
	def initialize(taille)
	
		super(@taille." X ".@taille, false)
		@taille = taille
		
	end
	
end