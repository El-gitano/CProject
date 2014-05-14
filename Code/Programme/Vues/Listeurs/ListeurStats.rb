# encoding: utf-8 
require 'gtk2'
require_relative 'Listeur'

#Cette classe présente les sauvegardes d'un joueur
class ListeurStats < Listeur

	@modeleTV
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)
		@treeView.selection.mode = Gtk::SELECTION_NONE 
		set_size_request(900,150)

		@modeleTV = Gtk::ListStore.new(String, String, String, Integer, Integer, Integer, Integer)
		
		maj
		
		@treeView.model = @modeleTV
 
		#On définit + ajoute les colonnes
		listeColonnes = Array.new
		renderer = Gtk::CellRendererText.new
		
		listeColonnes.push(Gtk::TreeViewColumn.new("Joueur", renderer, "text" => 0))
		listeColonnes.push(Gtk::TreeViewColumn.new("Taux de réussite", renderer, "text" => 1))
		listeColonnes.push(Gtk::TreeViewColumn.new("Temps joué", renderer, "text" => 2))
		listeColonnes.push(Gtk::TreeViewColumn.new("Jokers utilisés", renderer, "text" => 3))
		listeColonnes.push(Gtk::TreeViewColumn.new("Indices utilisés", renderer, "text" => 4))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nombre de clics", renderer, "text" => 5))
		listeColonnes.push(Gtk::TreeViewColumn.new("Nombre de ragequits", renderer, "text" => 6))

		linkerColonnes(listeColonnes)
		ligneSurbrillance(listeColonnes, renderer)
		
		return self
	end
	
	#Met à jour le modèle du Listeur
	def maj
	
		@modeleTV.clear
		donnees = @modele.infosStats

		donnees.each{|ligne|

			entree = @modeleTV.append

			#Nom joueur
			entree[0] = ligne[0]
			
			#Traitement du taux de réussite
			if ligne[2].eql?(0) then
			
				entree[1] = (0.0).to_s
			
			else
			
				entree[1] = ((ligne[1].to_f / ligne[2].to_f) * 100.0).to_s + "%"
			end
			
			#Traitement du temps joué
			entree[2] = genererTemps(ligne[2])
			
			#On ajout les entrées de la requête dans notre modèle
			3.upto(6){|i|
				entree[i] = ligne[i]
			}
		}
	
	end
	
	#Génère une chaîne hh:mm:ss à partir d'un entier
	def genererTemps(unInt)
	
		heures = unInt/3600
		minutes = (unInt - (heures*3600)) / 60
		secondes = unInt - (heures*3600) - (minutes*60)


		h = heures < 10 ? "0" + heures.to_s : heures.to_s
		m = minutes < 10 ? "0" + minutes.to_s : minutes.to_s
		s = secondes < 10 ? "0" + secondes.to_s : secondes.to_s
			
		return h + "h" + m + "m" + s + "s"
	end
	
	#Met en couleur (ici rouge) la ligne du joueur actuel
	def ligneSurbrillance(lesColonnes, renderer)
	
		lesColonnes.each{|col|
		
			col.set_cell_data_func(renderer){|col, renderer, model, iter|
			
				if iter[0].eql?(@modele.getPseudo)
				
					renderer.foreground = "red"
					
				else
				
					renderer.foreground = nil
				end
			}
		}
	end
end
