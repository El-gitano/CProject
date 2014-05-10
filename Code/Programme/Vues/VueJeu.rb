#encoding: UTF-8

require './Vues/Vue'
require 'gtk2'

class VueJeu < Vue

	@miSauvegarder
	@miQuitter
	@miRageQuit
	
	@lbTimer
	@lbNomGrille
	
	@btJoker
	@btIndice
	@btVerifier
	
	@grille
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele)
		
		#VBox principale
		vbox = Gtk::VBox.new(false, 5)
		
		vbox.pack_start(creerMenu)
		vbox.pack_start(creerEntete)
		vbox.pack_start(creerPlateau)
		
		@btVerifier = Gtk::Button.new("Vérifier")
		vbox.pack_start(@btVerifier)
		
		vbox.set_border_width(5)
		
		@window.add(vbox)
		@window.show_all
	end
	
	#Crée le menu en haut de la fenêtre de jeu
	def creerMenu
	
		mb = Gtk::MenuBar.new
		
		#Niveau 1
		fichier = Gtk::MenuItem.new("Fichier")
		@miRageQuit = Gtk::MenuItem.new("RageQuit")
		
		#Niveau 2 (Fichier)
		menuFichier = Gtk::Menu.new
		@miSauvegarder = Gtk::MenuItem.new("Sauvegarder")
		@miQuitter = Gtk::MenuItem.new("Quitter")
		
		menuFichier.append(@miSauvegarder)
		menuFichier.append(@miQuitter)
		
		fichier.set_submenu(menuFichier)
		
		mb.append(fichier)
		mb.append(@miRageQuit)
		
		return mb
	end
	
	#Crée la tête de la fenêtre (Timer - NomGrille - HBoxAide)
	def creerEntete
	
		hbox = Gtk::HBox.new(false, 50)
		
		@lbTimer = Gtk::Label.new(genererTemps(@modele.temps))
		@lbNomGrille = Gtk::Label.new(@modele.grilleSolution.nom)
		hboxAide = creerVBoxAide
		
		hbox.pack_start(@lbTimer)
		hbox.pack_start(@lbNomGrille)
		hbox.pack_start(hboxAide)
		
	end
	
	#Retourne un temps sous le format chronomètre à partir d'un entier
	def genererTemps(unNombre)
	
		return unNombre.to_s
	end
	
	#Crée une hBox contenant les boutons Joker et Indice
	def creerVBoxAide
	
		vbox = Gtk::VBox.new(false, 3)
		
		@btJoker = Gtk::Button.new
		@btIndice = Gtk::Button.new("Indice")
		
		vbox.pack_start(@btJoker)
		vbox.pack_start(@btIndice)
		
		return vbox
	end
	
	#Retourne une VBox contenant les informations sur une colonne
	def creerInfoColonne(unNombre)
	
		informations = @modele.infosGrille.infosColonne[unNombre]
		vbox = Gtk::VBox.new(false, 1)
		
		informations.each{|nombre|
		
			vbox.pack_end(Gtk::Label.new(nombre.to_s))
		}
		
		return vbox
	end
	
	#Retourne une HBox contenant les informations sur une ligne
	def creerInfoLigne(unNombre)
	
		informations = @modele.infosGrille.infosLigne[unNombre]
		hbox = Gtk::VBox.new(false, 1)
		
		informations.each{|nombre|
		
			vbox.pack_end(Gtk::Label.new(nombre.to_s))
		}
		
		return hbox
	end
	
	#Crée le plateau de jeu à partir de la grille du modèle
	def creerPlateau
	
		tailleGrille = @modele.tailleGrille
		@table = Gtk::Table.new(tailleGrille+1, tailleGrille+1, false)#On rajoute 1 pour insérer les infos des colonnes
		
		#Infos des colonnes
		1.upto(tailleGrille){|x|
		
			@table.attach(creerInfoColonne(x), x+1, x+2, 0, 1)
		}
		
		#Infos des lignes
		1.upto(tailleGrille){|y|
		
			@table.attach(creerInfoLigne(y), 0, 1, y+1, y+2)
		}
		
		#Création de la grille
		1.upto(tailleGrille){|x|
		
			1.upto(tailleGrille){|y|
			
				@table.attach(CaseVue.new("neutre", tailleGrille, x, y)
			}
		}
	end
	
	#Met à jour la vue à partir du modele
	def miseAJour
		
		#Mise à jour de toutes les cases du plateau à partir du modèle
		0.upto(@tailleGrille-1){|x|
			0.upto(@tailleGrille-1){|y|
				actualiserCase(x,y)
			}
		}
		
		@table.show_all
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
end
