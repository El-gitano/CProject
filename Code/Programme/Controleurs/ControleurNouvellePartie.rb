#encoding UTF-8

require_relative '../Vues/VueNouvellePartie'
require_relative '../Modeles/ModeleNouvellePartie'
require_relative 'Controleur'
require_relative 'ControleurAccueil'

class ControleurNouvellePartie < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleNouvellePartie.new(unProfil)
		@vue = VueNouvellePartie.new(@modele)
		@modele.ajouterObservateur(@vue)
		
		@vue.window.signal_connect("delete_event"){
		
			quitterJeu
		}
		
		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){
		
			changerControleur(ControleurJeu.new(@picross, @modele.profil, false, @vue.listeur.getSelection[0])) if !@vue.listeur.getSelection.nil?
		}
		
		#Retour à l'accueil
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurAccueil.new(@picross, @modele.profil))
		}
	end
end
