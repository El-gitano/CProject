#encoding: UTF-8
require 'gtk2'

class DialogueTuto < Gtk::Dialog
		
	def DialogueTuto.afficher(uneFenetre)
	
		d = new(uneFenetre)
		d.run
		d.destroy
	end
	
	def initialize(uneFenetre)
		
		super("Didacticiel", uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT,["Valider", Gtk::Dialog::RESPONSE_ACCEPT])
		
		# Creation des elements

		textview = Gtk::TextView.new
		textview.buffer.text = "Your 1st Gtk::TextView widget!"
		textview.buffer.text = "But du jeu\n
		Le but d'un hanjie est de noircir les cases de la grille afin de faire apparaître une image, un dessin. Les nombres à gauche et au-dessus de la grille sont là pour vous aider à déduire les cases à noircir.Quelles sont les cases à noircir?
Les nombres présents à gauche de la grille indiquent le nombre de cases à noircir sur la ligne correspondante. Les nombres présents en haut de la grille indiquent le nombre de cases à noircir sur la colonne correspondante.\n\n
		
		Pourquoi y-a-t-il plusieurs nombres?\n
		Un nombre 5 devant une ligne (à gauche de la grille donc) indique que vous devez noircir cinq cases à la suite sur cette même ligne. La séquence 3 2 signifie qu'il y a au moins une case vide entre une séquence de trois cases à noircir et une autre séquence de deux cases à noircir.
		
		Les cases faciles à noircir\n
		Il y a quelques astuces à connaitre afin de résoudre facilement un hanjie.Par exemple si le hanjie est une grille de 10 cases sur 10 cases, une colonne (ou une ligne) indiquant 10 signifie que toutes les cases de la colonne (ou de la ligne) doivent être noircies. Un autre exemple, si une ligne (ou une colonne) comporte 10 cases et que seules 7 cases sont à noircir, vous pouvez noircir les quatre cases centrales: ces cases seront noircies quelque soit la solution de cette ligne (ou de cette colonne). Cette astuce fonctionne dès qu'une ligne ou une colonne ne possède qu'un nombre et que ce nombre est strictement plus grand que la moitié des cases de cette ligne ou de cette colonne.
		
		Les cases à éliminer\n
		Vous pouvez aussi éliminer les cases qui ne sont évidemment pas à noircir, cela permet de voir plus clair dans la résolution du hanjie.Par exemple si une ligne contient trois cases à noircir et que vous avez déjà noircies ces trois cases, vous pouvez éliminer toutes les autres cases de cette ligne.\n\n"
		textview.set_editable(false)

		scrolled_win = Gtk::ScrolledWindow.new
		scrolled_win.border_width = 5
		scrolled_win.add(textview)
		scrolled_win.set_policy(Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS)

		# Ajout des elements
		vbox.add(scrolled_win)		
							
		show_all
	end
end
