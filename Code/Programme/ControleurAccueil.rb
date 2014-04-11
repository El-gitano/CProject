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

	
end
