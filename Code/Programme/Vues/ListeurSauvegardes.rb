require 'gtk2'

#Cette classe présente les sauvegardes d'un joueur
class ListeurSauvegardes < Gtk::ScrolledWindow

	@modele
	@treeView
	
	attr_reader :treeView
	
	def initialize(unModele)
	
		super()

		@modele = unModele

		modeleTV = Gtk::ListStore.new(String, String, Integer, Integer, String)
		
		donnees = @modele.infosSauvegardes

		donnees.each{|ligne|
			
			entree = modeleTV.append

			#On ajout les entrées de la requête dans notre modèle
			0.upto(4){|i|

				entree[i] = ligne[i]
			}
		}
		
		@treeView = Gtk::TreeView.new(modeleTV)
 
		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Sauvegarde", renderer, "text" => 0))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nom grille", renderer, "text" => 1))
		listeColonnes.push(Gtk::TreeViewColumn.new("Taille grille", renderer, "text" => 2))
		listeColonnes.push(Gtk::TreeViewColumn.new("Jokers restants", renderer, "text" => 3))
		listeColonnes.push(Gtk::TreeViewColumn.new("Date de la sauvegarde", renderer, "text" => 4))

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
