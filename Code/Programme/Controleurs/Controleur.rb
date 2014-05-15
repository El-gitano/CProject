#Les contrôleurs seront chargés de toute la logique de notre programme. Il déclarent la vue et le modèle dont ils ont besoin.
class Controleur

    @picross
    
    @vue
	@modele

	private_class_method :new
	
	attr_reader :picross
	
    def initialize(unJeu)
    
	    @picross = unJeu
	end
	
	#Change le contrôleur pour celui passé en paramètre
	def changerControleur(unControleur)
    
    	@vue.fermerFenetre
    	@modele.fermerBdd
    	@picross.controleur = unControleur
    end
    
    def quitterJeu
    
    	@modele.sauvegarderProfil if !@modele.nil?
    	Gtk.main_quit
    end
    
    def xorerBdd
    
    	pass = "L3SPI2014isTheBestPromotion"
    	
    	tabPass = pass.split(//)
    	
    	entree = File.open($fichierBDD, "r")
    	sortie = File.open($fichierBDD+".enc", "w")
    	
    	i = 0
    	
    	while c = entree.getc
    	
    		caractereEncodeur = tabPass[i]
    		xored = c.char[0] ^ caractereEncodeur
    		sortie.print(xored.chr)
    		i += 1
    		
    		i = 0 if i.eql?(tabPass.size - 1)
    	end
    	
    	entree.close
    	sortie.close
    end
end



