#encoding: UTF-8

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
		hash = @vue.listeur.modeleHash

		#Chargement de la grille sélectionnée
		@vue.btCharger.signal_connect("clicked"){
		@vue.listeur.getAllSelection.selected_each {|model, path, iter|
				
				hash[iter[0]].changerPseudo(unProfil.pseudo)
				hash[iter[0]].sauvegarderGrilleEditeur(iter[0])
			
				
			}
			DialogueInfo.afficher("Importation", "Importation réalisée avec succès", @vue.window)
		}
		
		#Retour à l'éditeur
		@vue.btRetour.signal_connect("clicked"){
		
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
		
	end
end
