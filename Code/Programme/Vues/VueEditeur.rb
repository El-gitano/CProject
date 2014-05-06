# encoding: UTF-8

require './Vue'
require './BoutonTaille'
require './CaseVue'

#Vue chargée d'effectuer le lien entre le contrôleur et l'utilisateur lors de l'écran d'accueil
class VueEditeur < Vue
	
	@boutonOuvrir
	@boutonEnregistrer
	@boutonImporterImage
	@boutonAleatoire
	@labelTaille
	@listBoutonTaille
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
	@mat
	
	attr_reader :boutonOuvrir, :boutonEnregistrer, :boutonImporterImage, :boutonAleatoire, :listBoutonTaille
	
	public_class_method :new
	
	def initialize()
	
		super()

		@window.set_size_request(620,750)
		@window.set_resizable(true) 
		@vbox = Gtk::VBox.new(false, 4)
		@vbox2 = Gtk::VBox.new(false, 2)
		@vbox3 = Gtk::VBox.new(false, 2)

		@hbox1 = Gtk::HBox.new(false, 0)
		@hbox2 = Gtk::HBox.new(false, 0)	
		@hbox3 = Gtk::HBox.new(false, 0)	
		
		@boutonOuvrir = Gtk::Button.new("Ouvrir", false)
		@boutonEnregistrer = Gtk::Button.new("Enregistrer", false)
		@boutonImporterImage = Gtk::Button.new("Importer depuis une image", false)
		@boutonAleatoire = Gtk::Button.new("Aléatoire", false)
		@labelTaille = Gtk::Label.new("Taille de la grille", false)
		
		@listBoutonTaille = Array.new
		5.step(25,5){ |x| 
			@listBoutonTaille.push(BoutonTaille.new(x))
		}


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
	
		@listBoutonTaille.each{|x|
			@hbox2.pack_start(x, true, false, 0)
		}


		##@vbox.pack_start(@hbox1, true, false, 0)
		#@vbox.pack_start(@vbox2, true, false, 0)

		@vbox.set_border_width(20) #On espace la vBox de la fenêtre
		@vbox3.set_spacing(20)
		@vbox3.pack_start(@hbox1, true, false, 0)
		@vbox3.pack_start(@vbox2, true, false, 0)
		@vbox.pack_start(@vbox3, true, false, 0)
		
		@mat = Array.new(10) { Array.new(10) }

		initialiserGrille(10)

		@window.add(@vbox)		
		@window.signal_connect('destroy') { Gtk.main_quit }
		@window.show_all
		
	end
	
	def initialiserGrille(tailleGrille)
   		 #@grille=Gtk::Table.new(tailleGrille,tailleGrille,true) 
		 posX = 10
		 posY = 10
		 @grille=Gtk::Fixed.new() 
		 0.upto(tailleGrille-1){|x|
			0.upto(tailleGrille-1){|y|
				@caseTest = CaseVue.new(x, y, "./Images/carreN.jpg")
				@mat[y][x] = @caseTest
				#@grille.attach_defaults(@caseTest, x, x+1, y, y+1)
				@grille.put(@caseTest, posX, posY)
				posX += 35
			}
			posX = 10
			posY += 35
		}
		
		@vbox.pack_start(@grille, true, true, 0)
	end
	
	def creerGrille(tailleGrille)
		 @grille.destroy
		 @mat = Array.new(tailleGrille) { Array.new(tailleGrille) }
   		 @grille=Gtk::Table.new(tailleGrille,tailleGrille,true) 
		 0.upto(tailleGrille-1){|x|
			0.upto(tailleGrille-1){|y|
				@caseTest = CaseVue.new(x, y, "./Images/carreB.png")
				@mat[y][x] = @caseTest
				@grille.attach_defaults(@caseTest, x, x+1, y, y+1)
			}
		}
		
		@vbox.pack_start(@grille, true, false, 0)
	end
	
	def actualiser()

		0.upto(@modele.grille.taille-1){|x|
			0.upto(@modele.grille.taille-1){|y|
				actualiserCase(x,y)
			}
		}
	end
	

	def actualiserCase(x,y)
		if(@modele.getCase(x,y).etat.neutre?)
			getGrilleXY(x,y).changerImageEtat("./Images/carreB.png")
		elsif(@modele.getCase(x,y).etat.croix?)
			getGrilleXY(x,y).changerImageEtat("./Images/croix2.png")
		elsif(@modele.getCase(x,y).etat.jouee?)
			getGrilleXY(x,y).changerImageEtat("./Images/carreN.png")
		end
	end


	def getGrilleXY(x, y)
		return @mat[y][x]
	end
	
end

Gtk.init
v= VueEditeur.new
Gtk.main
