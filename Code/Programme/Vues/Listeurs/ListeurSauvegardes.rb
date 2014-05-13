# encoding: utf-8 
require 'gtk2'
require_relative 'Listeur'

#Cette classe présente les sauvegardes d'un joueur
class ListeurSauvegardes < Listeur

	@modeleTV
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)

		@modeleTV = Gtk::ListStore.new(String, String, Integer, Integer, String)
		
		maj
		
		@treeView.model = @modeleTV
 
		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Sauvegarde", renderer, "text" => 0))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nom grille", renderer, "text" => 1))
		listeColonnes.push(Gtk::TreeViewColumn.new("Taille grille", renderer, "text" => 2))
		listeColonnes.push(Gtk::TreeViewColumn.new("Jokers restants", renderer, "text" => 3))
		listeColonnes.push(Gtk::TreeViewColumn.new("Date de la sauvegarde", renderer, "text" => 4))

		linkerColonnes(listeColonnes)
		
		return self
	end
	
	def maj
	
		@modeleTV.clear
		donnees = @modele.infosSauvegardes

		donnees.each{|ligne|
			
			entree = @modeleTV.append

			#On ajout les entrées de la requête dans notre modèle
			0.upto(4){|i|

				entree[i] = ligne[i]
			}
		}
	end
end
