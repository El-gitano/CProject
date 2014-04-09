require './ControleurDemarrage.rb'
require 'gtk2'

#Cette classe représente le jeu en lui même. Au cours du déroulement du programme les contrôleurs changeront, ayant pour conséquence de changer la vue et le modèle "temporaire" également.
class Picross

    @controleur

    attr_accessor :controleur

	private_class_method :new
	
	def Picross.Creer
	
		new
	end
	
    def initialize
    
    	Gtk.init
    	$fichierBDD = "test.sqlite"
    	
    	@controleur = ControleurDemarrage.new(self)
    	
    	Gtk.main
    end
end
