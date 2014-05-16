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
    	xorerBdd(false)
    	
    	@controleur = ControleurDemarrage.new(self)
    	
    	Gtk.main
    end
    
    def xorerBdd(crypter)
    
		pass = "L3SPI2014isTheBestPromotion"

		tabPass = pass.split(//)

		#On crypte
		if crypter then

			entree = File.open($fichierBDD, "r")
			sortie = File.open($fichierBDD+".enc", "w")

		#On décrypte
		else

			sortie = File.open($fichierBDD, "w")
			entree = File.open($fichierBDD+".enc", "r")
		end

		i = 0
		entree.each_byte{|b|
	
			caractereEncodeur = tabPass[i]
			xored = b ^ caractereEncodeur.ord
			sortie.print(xored.chr)
			i += 1
	
			i = 0 if i.eql?(tabPass.size - 1)
		}

		entree.close
		sortie.close
		
		#On crypte
		if crypter then

			File.delete($fichierBDD)

		#On décrypte
		else

			File.delete($fichierBDD+".enc")
		end
	end
end


p = Picross.Creer
