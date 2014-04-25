# encoding: UTF-8

require 'gtk2'

window = Gtk::Window.new("Picross accueil")

#On demande à l'utilisateur d'entrer un nom de grille
dialogue = Gtk::Dialog.new("Nom de sauvegarde", window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

dialogue.set_modal(true)

lbNomGrille = Gtk::Label.new("Nom de la grille : ")
etNomGrille = Gtk::Entry.new

hBox = Gtk::HBox.new(false, 5)

hBox.pack_start(lbNomGrille , false, false, 0)
hBox.pack_start(etNomGrille , false, false, 0)
dialogue.vbox.pack_start(hBox, false, false, 0)

nomGrille = nil

etNomGrille.signal_connect("changed"){

	nomGrille = etNomGrille.text
}

dialogue.show_all	
dialogue.run
dialogue.destroy
		
#On vérifie que la grille n'existe pas
if false then

	if true then

		dialogue = Gtk::Dialog.new("Sauvegarde de la grille", window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		dialogue.set_modal(true)
	
		hbox = Gtk::HBox.new(false, 5)

		label = Gtk::Label.new("Grille sauvegardée avec succès")
		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)

		dialogue.vbox.add(hbox)

		dialogue.show_all	
		dialogue.run

		dialogue.destroy

	else

		print "Erreur dans la sauvegarde de la grille"
		exit(-1)
	end

else
	dialogue = Gtk::Dialog.new("Grille existante", window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
	dialogue.set_modal(true)

	hbox = Gtk::HBox.new(false, 5)

	label = Gtk::Label.new("La grille " + nomGrille + " existe déjà !")
	image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

	hbox.pack_start(image, false, false, 0)
	hbox.pack_start(label, false, false, 0)

	dialogue.vbox.add(hbox)

	dialogue.show_all	
	dialogue.run

	dialogue.destroy
end
