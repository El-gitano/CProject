require_relative 'Controleurs/ControleurDemarrage'
require 'gtk2'

#Cette classe représente le jeu en lui même. Au cours du déroulement du programme les contrôleurs changeront, ayant pour conséquence de changer la vue et le modèle liés également.
class Picross

    @controleur

    attr_accessor :controleur

	private_class_method :new
	
	def Picross.Creer
	
		new
	end
	
    def initialize
    
    	Gtk.init
    	$fichierBDD = File.expand_path("bdd.sqlite", File.dirname(__FILE__))
    	
    	@controleur = ControleurDemarrage.new(self)
    	
    	Gtk.main
    end
end

p = Picross.Creer
