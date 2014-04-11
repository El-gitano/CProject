require 'gtk2'

class Fenetre

	def initialize
	
		Gtk.init()
		
		@window = Gtk::Window.new("Picross accueil")
		dialogue = Gtk::Dialog.new("Credits", @window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		
		# Creation des box
		hbox = Gtk::HBox.new(false, 5)
		vbox2 = Gtk::VBox.new(false, 5)
		vbox3 = Gtk::VBox.new(false, 5)
		vbox4 = Gtk::VBox.new(false, 5)

		# Creation des elements
		tabNoms = Array.new

		tabNoms.push(Gtk::Label.new("AYDIN Emre"))
		tabNoms.push(Gtk::Label.new("FOUCAULT Antoine"))
		tabNoms.push(Gtk::Label.new("GUENVER Loic"))
		tabNoms.push(Gtk::Label.new("LANVIN Elyan"))
		tabNoms.push(Gtk::Label.new("MARCAIS Thomas"))
		tabNoms.push(Gtk::Label.new("RAMOLET Arthur"))

		labelAnnee = Gtk::Label.new("Cree en 2014")
		labelUniv = Gtk::Label.new("Projet Universite du Maine")

		boutonOK = Gtk::Button.new("Ok", false)

		labelImage1 = Gtk::Label.new("IMAGE")
		labelImage2 = Gtk::Label.new("IMAGE")

		image1 = Gtk::Image.new("./univ.jpg")
		

		# Ajout des elements
		dialogue.vbox.add(hbox)
		hbox.add(vbox2)
		hbox.add(vbox3)
		hbox.add(vbox4)

		tabNoms.each{|x|

			vbox3.add(x)
		}

		vbox2.add(labelImage1)

		vbox3.add(labelAnnee)
		vbox3.add(labelUniv)

		vbox4.pack_start(image1, false, false, 0)

		# Affichage des elements et lancement de la fenetre
		dialogue.show_all

		dialogue.run
	end
end

test = Fenetre.new()
