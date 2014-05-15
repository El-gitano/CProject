#encoding UTF-8

require_relative '../Vues/VueOuvrirGrilleImport'
require_relative '../Modeles/ModeleOuvrirGrilleImport'
require_relative 'Controleur'
require_relative 'ControleurEditeur'

class ControleurOuvrirGrilleImport < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleOuvrirGrilleImport.new(unProfil)
		@vue = VueOuvrirGrilleImport.new(@modele)

		@modele.ajouterObservateur(@vue)
		
		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){
		@vue.listeur.getAllSelection.selected_each {|model, path, iter|
				
				iter[6].profil.changerPseudo(unPseudo)
				iter[6].sauvegarderGrilleEditeur(iter[0])
			
				
			}

		}
		
		#Retour à l'éditeur
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
		
	end
end
