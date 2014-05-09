# encoding: UTF-8

require './Modeles/ModeleAccueil'
require './Vues/VueAccueil'
require './Controleurs/Controleur'
require './Controleurs/ControleurEditeur'

require 'gtk2'

# Le contrôleur d'accueil permet d'accéder aux différents menu du jeu
class ControleurAccueil < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleProfil.new(unProfil)
		@vue = VueProfil.new(@modele)

		@modele.ajouterObservateur(@vue)	
		
		#Réinitialisation des statistiques
		@vue.boutonEffacer.signal_connect("button_press_event"){
		
			@modele.reinitialiserStatistiques
			@modele.lancerMaj
		}
		
		#Renommage du profil
		@vue.boutonRenommer.signal_connect("button_press_event"){
			
			#À compléter
			if not @modele.profilExiste() then
			
				@modele.renommerProfil()#Ajouter le nouveau nom souhaité
				@modele.lancerMaj
			else
			
				
			end
		}
	end
end
