# encoding: UTF-8

require_relative 'Vue'
require_relative 'BoutonTaille'
require_relative 'CaseVue'

#Vue chargée d'effectuer le lien entre le contrôleur et l'utilisateur lors de l'écran d'accueil
class VueEditeur < Vue
	
	@boutonOuvrir
	@boutonEnregistrer
	@boutonImporterImage
	@boutonAleatoire
	@boutonImporter
	@boutonExporter
	@boutonRetour
	@labelTaille
	@listBoutonTaille
	@sbNbJokers
	@grille
	@hbox1
	@hbox2
	@hbox3
	@vbox
	@vbox2
	
	#Utile pour retrouver une case à partir des coordonnees
	@mat
	@tailleGrille
	
attr_reader :boutonOuvrir, :boutonEnregistrer, :boutonImporterImage, :boutonAleatoire, :boutonRetour, :listBoutonTaille, :mat, :sbNbJokers,	:boutonImporter, :boutonExporter
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Éditeur")
		@tailleGrille = @modele.grille.taille
		
		tailleFenetreX = 640
		
		@window.set_size_request(tailleFenetreX, 750)
		@vbox = Gtk::VBox.new(false, 10)
		@vbox2 = Gtk::VBox.new(false, 2)
		@vbox3 = Gtk::VBox.new(false, 2)

		@hbox1 = Gtk::HBox.new(false, 0)
		@hbox2 = Gtk::HBox.new(false, 0)	
		@hbox3 = Gtk::HBox.new(false, 0)	
		
		@boutonOuvrir = Gtk::Button.new(" Ouvrir", false)
		@boutonEnregistrer = Gtk::Button.new(" Sauver", false)
		@boutonImporterImage = Gtk::Button.new(" Importer", false)
		@boutonAleatoire = Gtk::Button.new("Aléatoire", false)
		@boutonImporter = Gtk::Button.new(" Importer", false)
		@boutonExporter = Gtk::Button.new(" Exporter", false)
		@boutonRetour = Gtk::Button.new(" Retour", false)
		@labelTaille = Gtk::Label.new("Taille de la grille", false)
		
		nbBoutonsHaut = 6
		
		tailleBoutonHautX = (tailleFenetreX / nbBoutonsHaut) - ( nbBoutonsHaut)
		tailleBoutonHautY = 40
		
		@boutonOuvrir.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonEnregistrer.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonImporterImage.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonAleatoire.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonRetour.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonImporter.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonExporter.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		
		@listBoutonTaille = Array.new
		5.step(25,5){ |x|
		
			boutonTaille = BoutonTaille.new(x)
			boutonTaille.set_size_request(80, 30)
			@listBoutonTaille.push(boutonTaille)
		}
	
		imgOuvrir = Gtk::Image.new(File.expand_path("./Images/folder.png", File.dirname(__FILE__)))
		imgEnregistrer = Gtk::Image.new(File.expand_path("./Images/disquette.png", File.dirname(__FILE__)))
		imgImporterImage = Gtk::Image.new(File.expand_path("./Images/image2.png", File.dirname(__FILE__)))
		imgAleatoire = Gtk::Image.new(File.expand_path("./Images/aleatoire.png", File.dirname(__FILE__)))
		imgFermer = Gtk::Image.new(File.expand_path("./Images/retour.png", File.dirname(__FILE__)))
		imgImporter = Gtk::Image.new(File.expand_path("./Images/importer.png", File.dirname(__FILE__)))
		imgExporter = Gtk::Image.new(File.expand_path("./Images/exporter.png", File.dirname(__FILE__)))

		@boutonOuvrir.set_image(imgOuvrir)
		@boutonEnregistrer.set_image(imgEnregistrer)
		@boutonImporterImage.set_image(imgImporterImage)
		@boutonAleatoire.set_image(imgAleatoire)
		@boutonImporter.set_image(imgImporter)
		@boutonExporter.set_image(imgExporter)
		@boutonRetour.set_image(imgFermer)

		@hbox1.pack_start(@boutonOuvrir, true, false, 0)
		@hbox1.pack_start(@boutonEnregistrer, true, false, 0)
		#@hbox1.pack_start(@boutonImporterImage, true, false, 0)
		@hbox1.pack_start(@boutonAleatoire, true, false, 0)
		@hbox1.pack_start(@boutonImporter, true, false, 0)
		@hbox1.pack_start(@boutonExporter, true, false, 0)
		@hbox1.pack_start(@boutonRetour, true, false, 0)
		
		
		imgOuvrir.show()
		imgEnregistrer.show()
		imgImporterImage.show()
		imgAleatoire.show()
		imgFermer.show()
		imgImporter.show()
		imgExporter.show()

		@vbox2.pack_start(@labelTaille, true, false, 0)
		@vbox2.pack_start(@hbox2, true, false, 0)
	
		@listBoutonTaille.each{|x|
			@hbox2.pack_start(x, true, false, 0)
		}
		
		hBoxTemp = Gtk::HBox.new(false, 3)
		@sbNbJokers = Gtk::SpinButton.new(0, 5, 1)
		
		hBoxTemp.pack_start(Gtk::Label.new("Jokers : "), false, false, 0)
		hBoxTemp.pack_start(@sbNbJokers, false, false, 0)
		@hbox2.pack_start(hBoxTemp, true, false, 0)

		@vbox.set_border_width(20) #On espace la vBox de la fenêtre
		@vbox3.set_spacing(20)
		@vbox3.pack_start(@hbox1, true, false, 0)
		@vbox3.pack_start(@vbox2, true, false, 0)
		@vbox.pack_start(@vbox3, true, false, 0)

		creerGrille(@modele.grille.taille)

		@window.add(@vbox)		
		@window.signal_connect('destroy') { Gtk.main_quit }
		@window.show_all
		
	end
	
	#Crée une grille de taille "tailleGrille" à partir de cases de la taille adéquate
	def creerGrille(tailleGrille)
 
 		tailleWidget = 600
 		espacementCases = 2
 		tailleCase = tailleWidget/tailleGrille#Moins 1 pour l'espacement entre cases
		posY = 0
		
		#Définition du plateau de jeu (graphique) 
		@grille.destroy if not @grille.nil?
		@grille = Gtk::Table.new(tailleGrille, tailleGrille, false)
		@grille.set_size_request(tailleWidget, tailleWidget)
		
		@mat = Array.new(tailleGrille) { Array.new(tailleGrille) }

		0.upto(tailleGrille-1){|x|

			posX = 0

			0.upto(tailleGrille-1){|y|
			
				#On spécifie la position de la case
				caseTemp = CaseVue.new("neutre", tailleGrille, x, y)
				@mat[x][y] = caseTemp#Mat contient des références à nos objets afin de les faire évoluer aux évènements
				@grille.attach(caseTemp, x, x+1, y, y+1)
  				
				posX += tailleCase + 1
			}

			posY += tailleCase + 1
		}
		
		#Définition de l'espacement des cases toutes les 5 cases
		4.step(tailleGrille, 5){|i|
		
			@grille.set_row_spacing(i, espacementCases)
			@grille.set_column_spacing(i, espacementCases)
		}
		
		@grille.show_all
		@vbox.pack_start(@grille, true, true, 0)
	end
	
	#Actualise l'ensemble de la grille à partir du modèle
	def miseAJour()
		
		#On a changé la taille de la grille ou chargé une grille
		if @tailleGrille.nil? or not @modele.grille.taille.eql?(@tailleGrille) then
		
			@tailleGrille = @modele.grille.taille
			creerGrille(@tailleGrille)
		end
		
		#Mise à jour de toutes les cases du plateau à partir du modèle
		0.upto(@tailleGrille-1){|x|
			0.upto(@tailleGrille-1){|y|
				actualiserCase(x,y)
			}
		}
		
		#Mise à jour du nombre de jokersRestants
		@sbNbJokers.value = @modele.grille.nbJokers
		
		@grille.show_all
	end
	
	#Actualise la case située aux coordonnées (x,y)
	def actualiserCase(x,y)
		
		#Doit devenir....
		if @modele.getCase(x,y).neutre? and not getCaseVue(x, y).etat.eql?("neutre") then

			getCaseVue(x, y).changerEtat("neutre")
			 
		elsif @modele.getCase(x,y).croix? and not getCaseVue(x, y).etat.eql?("croix") then
		
			getCaseVue(x, y).changerEtat("croix")
			 
		elsif @modele.getCase(x,y).jouee? and not getCaseVue(x, y).etat.eql?("jouee") then

			getCaseVue(x, y).changerEtat("jouee")

		end
	end

	#Retourne une case de la grille
	def getCaseVue(x, y)
	
		return @mat[x][y]
	end
	
	def operationGrille
	
		@mat.each{|x|
		
			x.each{|y|
			
				yield y
			}
		}
	end
end
