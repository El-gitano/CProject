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
	
	@caseTest
	
	@imgCaseCroix
	@imgCaseNoire
	@imgCaseNeutre
	
	#Utile pour retrouver une case à partir des coordonnees
	@mat[][]
	
	attr_reader :boutonOuvrir, :boutonEnregistrer, :boutonImporterImage, :boutonAleatoire, :bouton, :bouton10, :bouton15, :bouton20, :bouton25
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)

		@window.set_size_request(1000,800)
		
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
		
		#@bouton5= Gtk::Button.new("5 X 5", false)
		#@bouton10 = Gtk::Button.new("10 X 10", false)
		#@bouton15 = Gtk::Button.new("15 X 15", false)
		#@bouton20 = Gtk::Button.new("20 X 20", false)
		#@bouton25 = Gtk::Button.new("25 X 25", false)
		
		@bouton5 = BoutonTaille.new(5)
		@bouton10 = BoutonTaille.new(10)
		@bouton15 = BoutonTaille.new(15)
		@bouton20 = BoutonTaille.new(20)
		@bouton25 = BoutonTaille.new(25)


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
		
		#Images utilisees pour la grille (LIEN A MODIFIER)
		@imgCaseCroix = Gtk::Image.new("./Images/folder.png")
		@imgCaseNoire = Gtk::Image.new("./Images/folder.png")
		@imgCaseNeutre = Gtk::Image.new("./Images/folder.png")
		
		initialiserGrille(10)

		@window.add(@vbox)		
		@window.signal_connect('destroy') { Gtk.main_quit }
		@window.show_all
		
	end
	
	def initialiserGrille(tailleGrille)
   		 @grille=Gtk::Table.new(tailleGrille,tailleGrille,true) 
		 0.upto(tailleGrille-1){|x|
			0.upto(tailleGrille-1){|y|
				@caseTest = CaseVue.new(x, y, @imgCaseNeutre)
				@mat[y][x] = @caseTest
				@grille.attach_defaults(@caseTest, x, x+1, y, y+1)
			}
		}
		
		@vbox.pack_start(@grille, true, true, 0)
	end
	
	
	
	def actualiser()
		@grille=Gtk::Table.new(tailleGrille,tailleGrille,true) 
		0.upto(@modele.grille.size-1){|x|
			0.upto(@modele.grille.size-1){|y|
				@caseTest = CaseVue.new(x, y, @imgCaseNeutre)
				@mat[y][x] = @caseTest
				@grille.attach_defaults(@caseTest, x, x+1, y, y+1)
			}
		}
	end
	
	def getGrilleXY(x, y)
		return @mat[y][x]
	end
	
end

Gtk.init
v= VueEditeur.new
Gtk.main
