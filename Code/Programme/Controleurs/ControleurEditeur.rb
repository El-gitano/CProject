# encoding: utf-8
class ControleurEditeur < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil)
		@vue = VueDemarrage.new(@modele)
		
		@modele.ajouterObservateur(@vue)
	end

	@vue.boutonOuvrir.signal_connect("clicked"){
	
	}
	
	@vue.boutonEnregistrer.signal_connect("clicked"){
	
	}
	
	@vue.boutonAleatoire.signal_connect("clicked"){
	
	}
	
	@vue.bouton5.signal_connect("clicked"){
	
	}
	
	@vue.bouton10.signal_connect("clicked"){
	
	}
	
	@vue.bouton15.signal_connect("clicked"){
	
	}
	
	@vue.bouton20.signal_connect("clicked"){
	
	}
	
	@vue.bouton25.signal_connect("clicked"){
	
	}
	
	# Retour a l'accueil
	def retourAccueil
	end
end
