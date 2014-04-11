class ControleurAccueil < Controleur

	# Constructeur
	def initialize(unJeu)

		super(unJeu)
	end

	@vue.boutonDeco.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonJouer.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonEditer.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonCredit.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonProfil.signal_connect("clicked"){
	
	
	}
end
