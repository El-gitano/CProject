# encoding: utf-8 
require 'gtk2'
require_relative 'Listeur'

#Cette classe présente les grilles éditables par un joueur
class ListeurGrillesEditables < Listeur

	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)

		@modeleTV = Gtk::ListStore.new(String, String, Integer, Integer, String, String)
		
		maj
		
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

		linkerColonnes(listeColonnes)

		return self
	end
	
	def maj
	
		@modeleTV.clear
		donnees = @modele.infosGrillesEditables
		
		donnees.each{|ligne|
			
			entree = @modeleTV.append

			#On ajout les entrées de la requête dans notre modèle
			0.upto(5){|i|
			
				entree[i] = ligne[i]
			}
		}
	end
end
