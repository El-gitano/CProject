# encoding: UTF-8

require './ModeleAccueil'
require './VueAccueil'
require './Controleur'

require 'gtk2'

# Le contrôleur d'accueil permet d'accéder 
class ControleurAccueil < Controleur

	# Constructeur
	def initialize(unJeu)

		super(unJeu)
		@modele = ModeleAccueil.new
		@vue = VueAccueil.new(@modele)

		@modele.ajouterObservateur(@vue)
		
	end

	@vue.boutonDeco.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonJouer.signal_connect("clicked"){
	
		changerControleur(ControleurJeu.new(@picross, @profil))
	}
	
	@vue.boutonEditer.signal_connect("clicked"){
	
		changerControleur(ControleurEditeur.new(@picross, @profil))
	}
	
	@vue.boutonCredit.signal_connect("clicked"){
	
	
	}
	
	@vue.boutonProfil.signal_connect("clicked"){
	
		changerControleur(ControleurProfil.new(@picross, @profil))
	}
end
