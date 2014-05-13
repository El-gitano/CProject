#Les contrôleurs seront chargés de toute la logique de notre programme. Il déclarent la vue et le modèle dont ils ont besoin.

class Controleur

    @picross
    
    @vue
	@modele

	private_class_method :new
	
    def initialize(unJeu)
    
	    @picross = unJeu
	end
	
	def changerControleur(unControleur)
    
    	@vue.fermerFenetre
    	
    	@picross.controleur = unControleur
    end
end



