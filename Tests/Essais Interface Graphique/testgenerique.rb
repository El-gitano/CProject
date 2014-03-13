require 'gtk2'

class Gui

	@builder
	@window
	@grille
	
	def initialize(fichier)
	
		Gtk.init()
		
		@builder = Gtk::Builder.new
		@builder.add_from_file(fichier)
		
		@window = @builder.get_object("window1")
		@window.set_window_position Gtk::Window::POS_CENTER
		@window.signal_connect('destroy') { Gtk.main_quit }
		
		@builder.connect_signals(){ |handler| 
      		puts "Connection d\'un signal à la méthode : '#{handler}'"
     		method(handler) 
    	}
    	
		@window.show_all
		
		Gtk.main()
	end

end

test = Gui.new()
