# encoding: UTF-8

require 'gtk2'


window = Gtk::Window.new("Picross accueil")
dialogue = Gtk::Dialog.new("Ouverture d'un plateau", window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

dialogue.set_size_request(550,200)
dialogue.set_modal(true)

comboBoxGrilles = Gtk::ComboBox.new(true)
	
}

ligneH = Gtk::HSeparator.new

lbNomGrille = Gtk::Label.new("Le nom du plateau")

hBox = Gtk::HBox.new(false, 5)

#Création de l'intérieur de la boite de dialogue
lbNbJoker = Gtk::Label.new("Jokers : ")
lbTaille = Gtk::Label.new("Taille : ")
lbDateCreation = Gtk::Label.new("Date de création : ")

hBox.pack_start(lbNbJoker, false, false, 0)
hBox.pack_start(lbTaille, false, false, 0)
hBox.pack_start(lbDateCreation, false, false, 0)

#Ajout à la vbox par défaut
dialogue.vbox.pack_start(comboBoxGrilles, false, false, 0)
dialogue.vbox.pack_start(nomGrille, false, false, 0)
dialogue.vbox.pack_start(hBox, false, false, 0)

comboBoxGrilles.signal_connect("changed"){

	nomGrille = comboBoxGrilles.active_text
	lbNomGrille.text = nomGrill
	
	lbNbJokers.text = grille.jokers
	lbTaille.text = grille.taille.to_s + "X" + grille.taille.to_s
	lbDateCreation = grille.dateCreation
}

dialogue.show_all

dialogue.run{|reponse|

	#On ne traite la réponse que si l'utilisateur a cliqué sur "OPEN"
	case reponse
	
		when Gtk::Dialog::RESPONSE_ACCEPT
		
			print 'ok'
	end
}

dialogue.destroy
