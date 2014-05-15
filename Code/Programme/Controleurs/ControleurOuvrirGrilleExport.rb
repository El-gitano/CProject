#encoding: UTF-8

require_relative '../Vues/VueOuvrirGrilleExport'
require_relative '../Modeles/ModeleOuvrirGrilleExport'
require_relative 'Controleur'
require_relative 'ControleurEditeur'

class ControleurOuvrirGrilleExport < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleOuvrirGrilleExport.new(unProfil)
		@vue = VueOuvrirGrilleExport.new(@modele)

		@modele.ajouterObservateur(@vue)
		
		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){

			@vue.listeur.getAllSelection.selected_each {|model, path, iter|
				tmpGrille = ModeleGrille.new(@modele.profil)
				tmpGrille.charger(iter[0]) 
				tmpGrille.grille.exporterGrille("./Export/"+iter[0]+".grid")
			}
			DialogueInfo.afficher("Exportation", "Exportation réalisée avec succès", @vue.window)
		}
		
		#Retour à l'éditeur
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
		
	end
end
