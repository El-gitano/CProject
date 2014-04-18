# encoding: UTF-8

require './Vue'

#Vue chargée d'effectuer le lien entre le contrôleur et l'utilisateur lors de l'écran d'accueil
class VueEditeur < Vue
	
	@boutonOuvrir
	@boutonEnregistrer
	@boutonImporterImage
	@boutonAleatoire
	@labelTaille
	@bouton5
	@bouton10
	@bouton15
	@bouton20
	@bouton25
	@grille
	@hbox1
	@hbox2
	@hbox3
	@vbox
	@vbox2
	@boutonTest
	attr_reader :boutonOuvrir, :boutonEnregistrer, :boutonImporterImage, :boutonAleatoire, :bouton, :bouton10, :bouton15, :bouton20, :bouton25
	
	public_class_method :new
	
	def initialize()
	
		super()

		#Lignes de code commentées pour les tests
		@window.set_size_request(1000,800)
		
		#Cette box contient les 5 lignes champs + bouton
		@vbox = Gtk::VBox.new(false, 4)
		@vbox2 = Gtk::VBox.new(true, 2)

		@hbox1 = Gtk::HBox.new(false, 0)
		@hbox2 = Gtk::HBox.new(false, 0)	
		@hbox3 = Gtk::HBox.new(false, 0)	

		@boutonOuvrir = Gtk::Button.new("Ouvrir", false)
		@boutonEnregistrer = Gtk::Button.new("Enregistrer", false)
		@boutonImporterImage = Gtk::Button.new("Importer depuis une image", false)
		@boutonAleatoire = Gtk::Button.new("Aléatoire", false)
		@labelTaille = Gtk::Label.new("Taille de la grille", false)
		@bouton5= Gtk::Button.new("5 X 5", false)
		@bouton10 = Gtk::Button.new("10 X 10", false)
		@bouton15 = Gtk::Button.new("15 X 15", false)
		@bouton20 = Gtk::Button.new("20 X 20", false)
		@bouton25 = Gtk::Button.new("25 X 25", false)






		@boutonOuvrir.set_image(Gtk::Image.new("./Images/folder.png"))
		@boutonEnregistrer.set_image(Gtk::Image.new("./Images/disquette.png"))
		@boutonImporterImage.set_image(Gtk::Image.new("./Images/image2.png"))
		@boutonAleatoire.set_image(Gtk::Image.new("./Images/aleatoire.png"))


		


		@hbox1.pack_start(@boutonOuvrir, true, false, 0)
		@hbox1.pack_start(@boutonEnregistrer, true, false, 0)
		@hbox1.pack_start(@boutonImporterImage, true, false, 0)
		@hbox1.pack_start(@boutonAleatoire, true, false, 0)
		
		@vbox2.pack_start(@labelTaille, true, false, 0)
		@vbox2.pack_start(@hbox2, true, false, 0)	

		@hbox2.pack_start(@bouton5, true, false, 0)
		@hbox2.pack_start(@bouton10, true, false, 0)
		@hbox2.pack_start(@bouton15, true, false, 0)
		@hbox2.pack_start(@bouton20, true, false, 0)
		@hbox2.pack_start(@bouton25, true, false, 0)

		@vbox.pack_start(@hbox1, true, false, 0)
		@vbox.pack_start(@vbox2, true, false, 0)

		dessinerGrille(10)

		@window.add(@vbox)		
		@window.signal_connect('destroy') { Gtk.main_quit }
		@window.show_all
		
	end
	
	def dessinerGrille(tailleGrille)
   		 @grille=Gtk::Table.new(tailleGrille,tailleGrille,TRUE) 
		 0.upto(tailleGrille-1){|x|
			0.upto(tailleGrille-1){|y|
				@boutonTest = Gtk::Button.new("", false)
				@boutonTest.set_image(Gtk::Image.new("./Images/croix2.png"))
				@grille.attach_defaults(@boutonTest, x, x+1, y, y+1)
			}
		}
		
		@vbox.pack_start(@grille, true, true, 0)
 
	end
end

Gtk.init
v= VueEditeur.new
Gtk.main
