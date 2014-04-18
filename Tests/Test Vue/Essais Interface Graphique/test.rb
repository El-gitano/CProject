# encoding: UTF-8
require 'gtk2'

class Gui

	@builder
	@window
	@grille
	
	def initialize
	
		Gtk.init()
		
		@builder = Gtk::Builder.new
		@builder.add_from_file("plateau_editeur.glade")
		
		@window = @builder.get_object("window1")
		@window.set_window_position Gtk::Window::POS_CENTER
		@window.signal_connect('destroy') { Gtk.main_quit }
		
		@builder.connect_signals(){ |handler| 
      		puts "Connection d\'un signal a la methode : '#{handler}'"
     		method(handler) 
    	}
    	
		#creerGrille(25)
		@window.show_all
		
		Gtk.main()
	end

	def creerGrille(taille)
		
		if @grille != nil then
		
			@builder.get_object("as1").remove(@grille)
			
		end
		
		@grille = Gtk::Table.new(taille, taille, true)
	
		0.upto(taille-1){|x|
	
			0.upto(taille-1){|y|
		
				@grille.attach(Gtk::Label.new("  a  ", true), x, x+1, y, y+1, Gtk::EXPAND, Gtk::EXPAND, 0, 0)
			}
		}
	
		vbox = @builder.get_object("as1")
		vbox.pack_end(@grille, true, true, 0)
	
		@window.show_all
	end	
	
	def on_button5_clicked
	
		creerGrille(5)
	
	end
	
	def on_button6_clicked
	
		creerGrille(10)
	
	end
	
	def on_button7_clicked
	
		creerGrille(15)
	
	end
	
	def on_button8_clicked
	
		creerGrille(20)
	
	end
	
	def on_button9_clicked
	
		creerGrille(25)
		
	end
end

test = Gui.new()
