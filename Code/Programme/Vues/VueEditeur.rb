# encoding: UTF-8

require './Vues/Vue'
require './Vues/BoutonTaille'
require './Vues/CaseVue'

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
	
	#Utile pour retrouver une case à partir des coordonnees
	@mat
	@tailleGrille
	
attr_reader :boutonOuvrir, :boutonEnregistrer, :boutonImporterImage, :boutonAleatoire, :listBoutonTaille, :mat
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)
		@tailleGrille = @modele.grille.taille
		
		tailleFenetreX = 640
		
		@window.set_size_request(tailleFenetreX, 750)
		@window.set_resizable(false) 
		@vbox = Gtk::VBox.new(false, 10)
		@vbox2 = Gtk::VBox.new(false, 2)
		@vbox3 = Gtk::VBox.new(false, 2)

		@hbox1 = Gtk::HBox.new(false, 0)
		@hbox2 = Gtk::HBox.new(false, 0)	
		@hbox3 = Gtk::HBox.new(false, 0)	
		
		@boutonOuvrir = Gtk::Button.new("Ouvrir", false)
		@boutonEnregistrer = Gtk::Button.new("Enregistrer", false)
		@boutonImporterImage = Gtk::Button.new("Importer", false)
		@boutonAleatoire = Gtk::Button.new("Aléatoire", false)
		@labelTaille = Gtk::Label.new("Taille de la grille", false)
		
		nbBoutonsHaut = 4
		
		tailleBoutonHautX = (tailleFenetreX / nbBoutonsHaut) - (5 * nbBoutonsHaut)
		tailleBoutonHautY = 40
		
		@boutonOuvrir.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonEnregistrer.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonImporterImage.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		@boutonAleatoire.set_size_request(tailleBoutonHautX, tailleBoutonHautY)
		
		@listBoutonTaille = Array.new
		5.step(25,5){ |x|
			boutonTaille = BoutonTaille.new(x)
			boutonTaille.set_size_request(80, 30)
			@listBoutonTaille.push(boutonTaille)
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
 		tailleCase = tailleWidget/tailleGrille - 1#Moins 1 pour l'espacement entre cases
		posY = 0
		
		#Définition du plateau de jeu (graphique) 
		@grille.destroy if not @grille.nil?
		@grille = Gtk::Table.new(tailleGrille, tailleGrille, false)
		@grille.set_row_spacings(1)
		@grille.set_column_spacings(1)
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
	
	#Dialogue lorsq'un nom de grille vide est entré pour la sauvegarde
	def dgGrilleVide
	
		d = Gtk::Dialog.new("Grille non renseignée", @window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		d.set_modal(true)

		hbox = Gtk::HBox.new(false, 5)

		label = Gtk::Label.new("Veuillez renseigner un nom de grille s'il vous plaît")
		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)

		d.vbox.add(hbox)

		d.show_all	
		d.run

		d.destroy
	end
	
	#Dialogue de sauvegarde de la grille
	def dgGrilleSauv
	
		d = Gtk::Dialog.new("Sauvegarde de la grille", @window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		d.set_modal(true)

		hbox = Gtk::HBox.new(false, 5)

		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
		label = Gtk::Label.new("Grille sauvegardée avec succès")

		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)

		d.vbox.add(hbox)

		d.show_all	
		d.run
		d.destroy
	end
	
	def operationGrille
	
		@mat.each{|x|
		
			x.each{|y|
			
				yield y
			}
		}
	end
end
