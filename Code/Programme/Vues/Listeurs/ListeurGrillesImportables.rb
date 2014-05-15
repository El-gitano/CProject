# encoding: utf-8 
require 'gtk2'
require_relative 'Listeur'

#Cette classe présente les grilles jouables par un joueur
class ListeurGrillesImportables < Listeur

	public_class_method :new
	
	def initialize(unModele,multiselection = false)
	
		super(unModele)

		@modeleTV = Gtk::ListStore.new(String, String, Integer, Integer, String, String)
		
		maj

		@treeView.selection.mode=Gtk::SELECTION_MULTIPLE if multiselection

		@treeView.model = @modeleTV
 

		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Nom", renderer, "text" => 0))
		listeColonnes.push(Gtk::TreeViewColumn.new("Créateur", renderer, "text" => 1))
		listeColonnes.push(Gtk::TreeViewColumn.new("Taille", renderer, "text" => 2))
		listeColonnes.push(Gtk::TreeViewColumn.new("Jokers", renderer, "text" => 3))
		listeColonnes.push(Gtk::TreeViewColumn.new("Date création", renderer, "text" => 4))
		listeColonnes.push(Gtk::TreeViewColumn.new("Date modification", renderer, "text" => 5))
		#listeColonnes.push(Gtk::TreeViewColumn.new("Data", renderer))


		linkerColonnes(listeColonnes)

		return self
	end

	def maj
	
		@modeleTV.clear
		donnees = @modele.infosGrillesImportables
					

		donnees.each{|ligne|
			#print "ligne :",ligne.grille.nomGrille
			entree = @modeleTV.append

			#On ajout les entrées de la requête dans notre modèle			
				entree[0] = ligne.grille.nomGrille
				entree[1] = ligne
				entree[2] = ligne.grille.taille
				entree[3] = ligne.grille.nbJokers
				entree[4] = ligne.grille.dateCreation
				entree[5] = ligne.grille.dateModification
				#entree[6] = ligne
		}

	end
end
