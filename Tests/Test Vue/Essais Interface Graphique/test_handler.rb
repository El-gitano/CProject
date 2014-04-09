require 'gtk2'

class Gui

	@builder
	@window
	@bouton
	@nbClic
	
	def initialize(fichier)
	
		Gtk.init()
		
		@builder = Gtk::Builder.new
		@builder.add_from_file(fichier)
		
		@window = @builder.get_object("window1")
		@window.set_window_position Gtk::Window::POS_CENTER_ALWAYS
		@window.signal_connect('destroy') { Gtk.main_quit }
		
		@bouton = @builder.get_object("button1")
		
		@builder.connect_signals(){ |handler| 
	  		puts "Connection d\'un signal à la méthode : '#{handler}'"
	 		method(handler) 
		}
    	
    	@nbClic = 0
    	
		@window.show_all
		
		Gtk.main()
	end
	
	def on_button1_clicked(ancienBouton)
	
		@nbClic += 1
		@bouton.label="Cliqué #{@nbClic} fois\nTexte de l'ancien bouton :\n#{ancienBouton.label}"
		
		@window.show_all
	end
end

test = Gui.new("test_handler.glade")
