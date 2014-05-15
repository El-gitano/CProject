#Les classes héritées de Listeur contiendront un ensemble de données présentées dans un GtkTreeView contenu dans une ScrolledWindow
class Listeur < Gtk::ScrolledWindow

	@treeView
	@modele
	
	private_class_method :new
	
	def initialize(unModele)
	
		super()
		
		@modele = unModele
		@treeView = Gtk::TreeView.new
		
		add(@treeView)
		set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_AUTOMATIC)
		border_width = 5
	end
	
	#Retourne la ligne selectionnée par l'utilisateur
	def getSelection
	
		return @treeView.selection.selected
	end

	def getAllSelection
	
		return @treeView.selection
	end
	
	#Active le triage sur un tableau de colonnes et les ajoutent au treeView
	def linkerColonnes(listeColonnes)
	
		listeColonnes.each_with_index{|col, index|
			
			col.sort_indicator = true
  			col.sort_column_id = index
  			
  			col.signal_connect('clicked'){ |col|

   				col.sort_order =  (col.sort_order == Gtk::SORT_ASCENDING) ? Gtk::SORT_DESCENDING : Gtk::SORT_ASCENDING
  			}
  			
  			@treeView.append_column(col)
		}
		
		show_all
	end
end
