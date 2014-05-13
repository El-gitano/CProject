# encoding: utf-8 
require 'gtk2'

#Cette classe présente les sauvegardes d'un joueur
class ListeurStats < Gtk::ScrolledWindow

	@modele
	@modeleTV
	@treeView
	
	attr_reader :treeView
	
	def initialize(unModele)
	
		super()
		set_size_request(900,150)
		@modele = unModele

		@modeleTV = Gtk::ListStore.new(String, String, String, Integer, Integer, Integer, Integer)
		
		maj
		
		@treeView = Gtk::TreeView.new(@modeleTV)
 
		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Joueur", renderer, "text" => 0))
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
	
	#Met à jour le modèle du Listeur
	def maj
	
		@modeleTV.clear
		donnees = @modele.infosStats

		donnees.each{|ligne|

			entree = @modeleTV.append

			entree[0] = ligne[0]
			
			#Traitement du taux de réussite
			entree[1] = ligne[0].nil? ? "0" : ligne[0].to_s
			entree[1] += "%"
			
			#Traitement du temps joué
			entree[2] = genererTemps(ligne[1])
			
			#On ajout les entrées de la requête dans notre modèle
			3.upto(6){|i|
				entree[i] = ligne[i]
			}
		}
	
	end
	
	def genererTemps(unInt)
	
		heures = unInt/3600
		minutes = (unInt - (heures*3600)) / 60
		secondes = unInt - (heures*3600) - (minutes*60)


		h = heures < 10 ? "0" + heures.to_s : heures.to_s
		m = minutes < 10 ? "0" + minutes.to_s : minutes.to_s
		s = secondes < 10 ? "0" + secondes.to_s : secondes.to_s
			
		return h + "h" + m + "m" + s + "s"
	end
end
