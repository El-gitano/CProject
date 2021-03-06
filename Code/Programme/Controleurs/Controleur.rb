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
    
    	@modele.sauvegarderProfil if !@modele.profil.nil?
    	Gtk.main_quit
    end
end



