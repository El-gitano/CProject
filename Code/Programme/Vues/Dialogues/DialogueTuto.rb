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
		
		# Creation des conteneurs, 1 Alignment par Label
		align1 = Gtk::Alignment.new(0, 0, 1, 1)
		align2 = Gtk::Alignment.new(0, 0, 1, 1)
		align3 = Gtk::Alignment.new(0, 0, 1, 1)
		align4 = Gtk::Alignment.new(0, 0, 1, 1)
		align5 = Gtk::Alignment.new(0, 0, 1, 1)
		align6 = Gtk::Alignment.new(0, 0, 1, 1)
		align7 = Gtk::Alignment.new(0, 0, 1, 1)
		align8 = Gtk::Alignment.new(0, 0, 1, 1)
		align9 = Gtk::Alignment.new(0, 0, 1, 1)
		align10 = Gtk::Alignment.new(0, 0, 1, 1)

		# Creation des elements
		lbDidac1 = Gtk::Label.new
		lbDidac2 = Gtk::Label.new("Le but est de noircir les cases de la grille afin de faire apparaître une image.\n")

		lbDidac3 = Gtk::Label.new
		lbDidac4 = Gtk::Label.new("Les nombres présents à gauche de la grille indiquent le nombre de cases à noircir sur la ligne correspondante.\nLes nombres présents en haut de la grille indiquent le nombre de cases à noircir sur la colonne correspondante.\n")


		lbDidac5 = Gtk::Label.new
		lbDidac6 = Gtk::Label.new("Un nombre 5 devant une ligne (à gauche de la grille donc) indique que vous devez noircir cinq cases à la suite sur cette même ligne.\nLa séquence 3 2 signifie qu'il y a au moins une case vide entre une séquence de trois cases et une autre de deux cases à noircir.\n")

		lbDidac7 = Gtk::Label.new
		lbDidac8 = Gtk::Label.new("Si le hanjie est une grille de 10 cases sur 10 cases, une ligne/colonne indiquant 10 signifie que toutes les cases doivent être noircies.\n")

		lbDidac9 = Gtk::Label.new
		lbDidac10 = Gtk::Label.new("Vous pouvez aussi éliminer les cases qui ne sont évidemment pas à noircir, cela permet de voir plus clair dans la résolution du hanjie. \nSi une ligne contient trois cases à noircir et que vous avez déjà noircies ces trois cases, éliminez toutes les autres cases de cette ligne.\n")

		# Les titres des labels sont definis et agrandis
		lbDidac1.set_markup('<span size="x-large">But du jeu</span>')
		lbDidac3.set_markup('<span size="x-large">Quelles sont les cases à noircir?</span>')
		lbDidac5.set_markup('<span size="x-large">Pourquoi y-a-t-il plusieurs nombres?</span>')
		lbDidac7.set_markup('<span size="x-large">Les cases faciles à noircir</span>')
		lbDidac9.set_markup('<span size="x-large">Les cases à éliminer</span>')

		# On encapsule chaque Label dans un Alignment
		align1.add(lbDidac1)
		align2.add(lbDidac2)
		align3.add(lbDidac3)
		align4.add(lbDidac4)
		align5.add(lbDidac5)
		align6.add(lbDidac6)
		align7.add(lbDidac7)
		align8.add(lbDidac8)
		align9.add(lbDidac9)
		align10.add(lbDidac10)

		# Imbrication des elements
		vbox.add(align1)
		vbox.add(align2)
		vbox.add(align3)
		vbox.add(align4)
		vbox.add(align5)
		vbox.add(align6)
		vbox.add(align7)
		vbox.add(align8)
		vbox.add(align9)
		vbox.add(align10)
	
		

		show_all
	end
end
