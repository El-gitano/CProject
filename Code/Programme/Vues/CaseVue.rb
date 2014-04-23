class CaseVue < Gtk::Button

	@x
	@y
	@imgEtat
	
	attr_reader :x, :y
	
	public_class_method :new
	
	def initialize(x, y, img)
	
		super("", false)
		self.set_image(img)
		@x, @y = x, y
		
	end
	
	def changerImageEtat(img)
		self.set_image(img)
	end
end