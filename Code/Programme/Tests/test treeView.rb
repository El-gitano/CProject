require 'gtk2'

Gtk.init

window = Gtk::Window.new("Picross accueil")

modele = Gtk::ListStore.new(Integer, String)
parents = modele.insert(nil)
iter[0] = 1
iter[1] = "Test"
modele.set_value(iter, 0, 1)
modele.set_value(iter, 1, "Test")

treeview = Gtk::TreeView.new(modele)
window.add(treeview)
window.show_all

Gtk.main
