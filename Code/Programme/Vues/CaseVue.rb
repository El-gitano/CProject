class CaseVue < Gtk::EventBox 

	@x
	@y
	@img
	
	attr_reader :x, :y, :img
	
	public_class_method :new
	
	def initialize(x, y, img)
	
		super(img)
		@x, @y = x, y
		
	end
	
	def changerImageEtat(img)
		self.set_image(img)
	end
end
