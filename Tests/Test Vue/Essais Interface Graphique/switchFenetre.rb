require 'gtk2'

class Gui

	@builder
	@fenetre
	
	attr_accessor :fenetre
	attr_accessor :builder
	
	def initialize()
	
		Gtk.init()
		@builder = Gtk::Builder.new
		@fenetre = Fenetre1.new(self).charger()
		Gtk.main()
		
	end	
end

class Fenetre

	@fichier_glade
	@fenetre
	@gui
	
	def initialize(gui)
	
		@gui = gui
		
	end
	
	def cacher()
	
		@fenetre.hide_all
	
	end
	
	def charger()
		
		@gui.fenetre.cacher if !@gui.fenetre.nil?
		
		@fenetre = @gui.builder.add_from_file(@fichier_glade).get_object("window1")
		@fenetre.set_window_position Gtk::Window::POS_CENTER_ALWAYS
		@fenetre.signal_connect('destroy') { Gtk.main_quit }
		
		@gui.builder.connect_signals(){ |handler| 
	  		puts "Connection d\'un signal à la méthode : '#{handler}'"
	 		method(handler) 
		}
		
		@fenetre.show_all
		
		return self
	end
end

class Fenetre1 < Fenetre

	def initialize(gui)
	
		super(gui)
		@fichier_glade = "switch_fenetre1.glade"
		
	end
	
	def f1on_button1_clicked()
		
		@gui.fenetre= Fenetre2.new(@gui).charger()
		
	end
end

class Fenetre2 < Fenetre

	def initialize(builder)
	
		super(builder)
		@fichier_glade = "switch_fenetre2.glade"
		
	end
	
	def f2on_button1_clicked()
	
		@gui.fenetre= Fenetre1.new(@gui).charger()
		
	end
end

test = Gui.new()
