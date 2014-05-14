require 'gtk2'

#Boîte de dialogue chargée de l'affichage du tutoriel
class DialogueTuto < Gtk::Dialog
		
	def DialogueTuto.afficher(uneFenetre)
	
		d = new(uneFenetre)
		d.run
		d.destroy
	end
	
	def initialize(uneFenetre)
		
		super("Didacticiel", uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT,["Valider", Gtk::Dialog::RESPONSE_ACCEPT])
		
		# Creation des elements
		lbDidac1 = Gtk::Label.new("But du jeu")
		lbDidac2 = Gtk::Label.new("Le but d'un hanjie est de noircir les cases de la grille afin de faire apparaître une image, un dessin. Les nombres à gauche et au-dessus de la grille sont là pour vous aider à déduire les cases à noircir.")
		
		lbDidac3 = Gtk::Label.new("Quelles sont les cases à noircir?")
		lbDidac4 = Gtk::Label.new("Les nombres présents à gauche de la grille indiquent le nombre de cases à noircir sur la ligne correspondante. Les nombres présents en haut de la grille indiquent le nombre de cases à noircir sur la colonne correspondante.")
		
		lbDidac5 = Gtk::Label.new("Pourquoi y-a-t-il plusieurs nombres?")
		lbDidac6 = Gtk::Label.new("Un nombre 5 devant une ligne (à gauche de la grille donc) indique que vous devez noircir cinq cases à la suite sur cette même ligne. La séquence 3 2 signifie qu'il y a au moins une case vide entre une séquence de trois cases à noircir et une autre séquence de deux cases à noircir. ")
		
		lbDidac7 = Gtk::Label.new("Les cases faciles à noircir")
		lbDidac8 = Gtk::Label.new("Il y a quelques astuces à connaitre afin de résoudre facilement un hanjie.Par exemple si le hanjie est une grille de 10 cases sur 10 cases, une colonne (ou une ligne) indiquant 10 signifie que toutes les cases de la colonne (ou de la ligne) doivent être noircies. Un autre exemple, si une ligne (ou une colonne) comporte 10 cases et que seules 7 cases sont à noircir, vous pouvez noircir les quatre cases centrales: ces cases seront noircies quelque soit la solution de cette ligne (ou de cette colonne). Cette astuce fonctionne dès qu'une ligne ou une colonne ne possède qu'un nombre et que ce nombre est strictement plus grand que la moitié des cases de cette ligne ou de cette colonne. ")
		
		lbDidac9 = Gtk::Label.new("Les cases à éliminer")
		lbDidac10 = Gtk::Label.new("Vous pouvez aussi éliminer les cases qui ne sont évidemment pas à noircir, cela permet de voir plus clair dans la résolution du hanjie.Par exemple si une ligne contient trois cases à noircir et que vous avez déjà noircies ces trois cases, vous pouvez éliminer toutes les autres cases de cette ligne. ")

		scrolled_window = Gtk::ScrolledWindow.new( nil, nil )
		scrolled_window.border_width = (10)
		scrolled_window.set_policy( Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS )

		# Ajout des elements
		vbox.add(lbDidac1)
		vbox.add(lbDidac2)			
		vbox.add(lbDidac3)
		vbox.add(lbDidac4)
		vbox.add(lbDidac5)		
		vbox.add(lbDidac6)   
		vbox.add(lbDidac7)
		vbox.add(lbDidac8)
		vbox.add(lbDidac9)
		vbox.add(lbDidac10)			
			
		vbox.pack_start( scrolled_window, true, true, 0 )
				
		show_all
	end
end
