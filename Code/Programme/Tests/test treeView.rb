require 'gtk2'

Gtk.init

window = Gtk::Window.new("Picross accueil")

modele = Gtk::ListStore.new(String, String)
ligne = modele.append
ligne[0] = 1
ligne[1] = "Test"


treeview = Gtk::TreeView.new(modele)

#On définit + ajoute les colonnes
listeColonnes = Array.new
renderer = Gtk::CellRendererText.new

listeColonnes.push(Gtk::TreeViewColumn.new("Nom", renderer, :text => 0))
listeColonnes.push(Gtk::TreeViewColumn.new("Créateur", renderer, :text => 1))
listeColonnes.push(Gtk::TreeViewColumn.new("Taille", renderer, :text => 2))
listeColonnes.push(Gtk::TreeViewColumn.new("Jokers", renderer, :text => 3))
listeColonnes.push(Gtk::TreeViewColumn.new("Date création", renderer, :text => 4))
listeColonnes.push(Gtk::TreeViewColumn.new("Date modification", renderer, :text => 5))

listeColonnes.each{|col|

	treeview.append_column(col)
}

window.add(treeview)
window.show_all

Gtk.main
