#encoding UTF-8

require_relative '../Vues/VueOuvrirGrille'
require_relative '../Modeles/ModeleOuvrirGrille'
require_relative 'Controleur'
require_relative 'ControleurEditeur'

# Le contrôleur export permet d'exporter une grille pour la transférer sur une autre machine
class ControleurExport < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		#@modele = ModeleOuvrirGrille.new(unProfil)
		@vue = VueOuvrirGrille.new(@modele)

		@modele.ajouterObservateur(@vue)
		
		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){
		
			changerControleur(ControleurEditeur.new(@picross, @modele.profil, @vue.listeur.getSelection[0])) if !@vue.listeur.getSelection.nil?
		}
		
		#Retour à l'éditeur
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
		
	end
end
