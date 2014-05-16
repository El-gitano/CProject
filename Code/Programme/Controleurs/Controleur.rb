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
    
    	xorerBdd(true)
    	@modele.sauvegarderProfil if !@modele.profil.nil?
    	Gtk.main_quit
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



