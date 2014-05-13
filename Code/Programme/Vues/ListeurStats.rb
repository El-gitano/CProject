# encoding: utf-8 
require 'gtk2'

#Cette classe présente les sauvegardes d'un joueur
class ListeurSauvegardes < Gtk::ScrolledWindow

	@modele
	@treeView
	
	attr_reader :treeView
	
	def initialize(unModele)
	
		super()

		@modele = unModele

		modeleTV = Gtk::ListStore.new(String, String, Integer, Integer, Integer, Integer)
		
		donnees = @modele.infosStats

		donnees.each{|ligne|
			
			entree = modeleTV.append

			#On ajout les entrées de la requête dans notre modèle
			0.upto(5){|i|

				entree[i] = ligne[i]
			}
		}
		
		@treeView = Gtk::TreeView.new(modeleTV)
 
		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Taux de réussite", renderer, "text" => 0))
		listeColonnes.push(Gtk::TreeViewColumn.new("Temps joué", renderer, "text" => 1))
		listeColonnes.push(Gtk::TreeViewColumn.new("Jokers utilisés", renderer, "text" => 2))
		listeColonnes.push(Gtk::TreeViewColumn.new("Indices utilisés", renderer, "text" => 3))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nombre de clics", renderer, "text" => 4))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nombre de ragequits", renderer, "text" => 5))

		#Les colonnes sont triables
		listeColonnes.each_with_index{|col, index|
			
			col.sort_indicator = true
  			col.sort_column_id = index
  			
  			col.signal_connect('clicked'){ |col|

   				col.sort_order =  (col.sort_order == Gtk::SORT_ASCENDING) ? Gtk::SORT_DESCENDING : Gtk::SORT_ASCENDING
  			}
  			
  			@treeView.append_column(col)
		}

		add(@treeView)
		set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
		border_width = 5
		return self
	end
end
