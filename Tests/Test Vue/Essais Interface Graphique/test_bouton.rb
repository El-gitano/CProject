# encoding: utf-8

require 'gtk2'

class Gui

	@builder
	@window
	@bouton
	
	def initialize(fichier)
	
		Gtk.init()
	
		@builder = Gtk::Builder.new
		@builder.add_from_file(fichier)
	
		@window = @builder.get_object("window1")
		@window.set_window_position Gtk::Window::POS_CENTER_ALWAYS
		@window.signal_connect('destroy') { Gtk.main_quit }
	
		@bouton = Bouton.new(@builder.get_object("button1"))
		@bouton.etat=EtatNonClique.new(@bouton)
		
		@window.show_all
	
		Gtk.main()
	end
end

class Bouton

	@etat
	@label
	
	attr_writer :etat
	attr_reader :label
	
	def initialize(unLabel)
	
		@label = unLabel
	end

	def clic()
	
		@etat.clic()
	end
	
	def appui()
	
		@etat.appui()
	end
end

class EtatBouton

	@bouton
	
	def initialize(unBouton)
	
		@bouton = unBouton
	end
end	
		
class EtatClique < EtatBouton

	def initialize(unBouton)
	
		super(unBouton)
		@bouton.label.label="Bouton en Etat cliqué"
		
		@bouton.label.signal_connect('clicked') do
		
			clic()
		end
		
		@bouton.label.signal_connect('pressed') do
		
			appui()
		end
	end
	
	def appui()
	
		@bouton.label.label="Bouton souris appuyé dans l'état cliqué"
	end
	
	def clic()
	
		@bouton.etat= EtatNonClique.new(@bouton)
	end
end

class EtatNonClique < EtatBouton

	def initialize(unBouton)
	
		super(unBouton)
		@bouton.label.label="Bouton en Etat non cliqué"
		
		@bouton.label.signal_connect('clicked') do
		
			clic()
		end
		
		@bouton.label.signal_connect('pressed') do
		
			appui()
		end
	end
	
	def appui()
	
		@bouton.label.label="Bouton souris appuyé dans l'état non cliqué"
	end
	
	def clic()
	
		@bouton.etat= EtatClique.new(@bouton)
	end
end

test = Gui.new("test_bouton.glade")
