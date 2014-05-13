#encoding UTF-8

require_relative '../Vues/VueChargerSauvegarde'
require_relative '../Modeles/ModeleChargerSauvegarde'
require_relative 'Controleur'
require_relative 'ControleurAccueil'

class ControleurChargerSauvegarde < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleChargerSauvegarde.new(unProfil)
		@vue = VueChargerSauvegarde.new(@modele)

		@modele.ajouterObservateur(@vue)
		
		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){
		
			changerControleur(ControleurJeu.new(@picross, @modele.profil, true, @vue.listeur.getSelection[0])) if !@vue.listeur.getSelection.nil?
		}
		
		#Retour à l'accueil
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurAccueil.new(@picross, @modele.profil))
		}
		
		#Supression de la grille sélectionnée
		@vue.btSupprimer.signal_connect("clicked"){
		
			@modele.supprimerSauvegarde(@vue.listeur.getSelection[0], @vue.listeur.getSelection[1]) if !@vue.listeur.getSelection.nil?
		}
	end
end
