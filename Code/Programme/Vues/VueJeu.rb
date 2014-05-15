#encoding: UTF-8

require_relative 'Vue'
require_relative 'CaseVue'

require 'gtk2'

class VueJeu < Vue

	@miSauvegarder
	@miQuitter
	@miRageQuit
	@miDidac
	
	@lbTimer
	@lbNomGrille
	
	@btJoker
	@btIndice
	
	@table
	@mat
	
	
	public_class_method :new
	
	attr_reader :miSauvegarder, :miQuitter, :miRageQuit, :lbTimer, :lbNomGrille, :btJoker, :btIndice, :table, :miDidac
	
	def initialize(unModele)
	
		super(unModele, "Jeu")
		
		#VBox principale
		vbox = Gtk::VBox.new(false, 5)
		@window.add(vbox)

		vbox.pack_start(creerMenu)
		vbox.pack_start(creerEntete)
		vbox.pack_start(creerPlateau)
		
		vbox.set_border_width(5)

		arial18 = Pango::FontDescription.new('Arial 20')
		@lbTimer.modify_font(arial18)

		miseAJour
		
		

		@window.show_all
	end
	
	#Crée le menu en haut de la fenêtre de jeu
	def creerMenu
	
		mb = Gtk::MenuBar.new
		
		#Niveau 1
		fichier = Gtk::MenuItem.new("Fichier")
		@miDidac = Gtk::MenuItem.new("Didacticiel")
		@miRageQuit = Gtk::MenuItem.new("RageQuit")
		
		#Niveau 2 (Fichier)
		menuFichier = Gtk::Menu.new
		@miSauvegarder = Gtk::MenuItem.new("Sauvegarder")
		@miQuitter = Gtk::MenuItem.new("Quitter")
		
		menuFichier.append(@miSauvegarder)
		menuFichier.append(@miQuitter)
		
		fichier.set_submenu(menuFichier)
		
		mb.append(fichier)
		mb.append(@miDidac)
		mb.append(@miRageQuit)
		
		return mb
	end
	
	#Crée la tête de la fenêtre (Timer - NomGrille - HBoxAide)
	def creerEntete
	
		hbox = Gtk::HBox.new(false, 50)
		
		@lbTimer = Gtk::Label.new
		@lbNomGrille = Gtk::Label.new(@modele.plateauJeu.nomGrille)
		vboxAide = creerVBoxAide
		
		hbox.pack_start(@lbTimer)
		hbox.pack_start(@lbNomGrille)
		hbox.pack_start(vboxAide)
		
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
	
		informations = @modele.informations.infosColonnes[unNombre]
		vbox = Gtk::VBox.new(false, 0)
		
		informations.each{|nombre|
		
			vbox.pack_end(Gtk::Label.new(nombre.to_s), false, false)
		}
		
		return vbox
	end
	
	#Retourne une HBox contenant les informations sur une ligne
	def creerInfoLigne(unNombre)
	
		informations = @modele.informations.infosLignes[unNombre]
		hbox = Gtk::HBox.new(false, 5)
		hbox.set_border_width(5)
		
		informations.each{|nombre|
		
			hbox.pack_end(Gtk::Label.new(nombre.to_s), false, false)
		}
		
		return hbox
	end
	
	#Crée le plateau de jeu à partir de la grille du modèle
	def creerPlateau
	
		tailleGrille = @modele.plateauJeu.taille
		espacementCases = 2
		
		@table = Gtk::Table.new(tailleGrille+1, tailleGrille+1, false)#On rajoute 1 pour insérer les infos des colonnes
		@mat = Array.new(tailleGrille) {Array.new(tailleGrille)}
		
		#Infos des colonnes
		0.upto(tailleGrille-1){|x|
		
			@table.attach(creerInfoColonne(x), x+1, x+2, 0, 1)
		}
		
		#Infos des lignes
		0.upto(tailleGrille-1){|y|
		
			@table.attach(creerInfoLigne(y), 0, 1, y+1, y+2)
		}
		
		#Création de la grille
				
		0.upto(tailleGrille-1){|x|
		
			0.upto(tailleGrille-1){|y|
			
				caseTemp = CaseVue.new("neutre", tailleGrille, x, y)
				@table.attach(caseTemp, x+1, x+2, y+1, y+2)
				@mat[x][y] = caseTemp
			}
		}
		
		#Définition de l'espacement des cases toutes les 5 cases
		5.step(tailleGrille, 5){|i|
		
			@table.set_row_spacing(i, espacementCases)
			@table.set_column_spacing(i, espacementCases)
		}
		
		return @table
	end
	
	#Met à jour la vue à partir du modele
	def miseAJour
		
		tailleGrille = @modele.plateauJeu.taille
		
		#Mise à jour de toutes les cases du plateau à partir du modèle
		0.upto(tailleGrille-1){|x|
			0.upto(tailleGrille-1){|y|
				actualiserCase(x,y)
			}
		}
		
		#Désactivation du bouton joker si plus de jokers
		if @modele.plateauJeu.nbJokers.eql?(0) then
		
			@btJoker.sensitive = false 
			@btJoker.label = "Jokers"
			
		else
		
			@btJoker.sensitive = true
			@btJoker.label = "Jokers (#{@modele.plateauJeu.nbJokers})"
		end
		
		
		@window.show_all

	end
	
	def miseAJourNomGrille
	
		@lbNomGrille.text = @modele.plateauJeu.nomGrille
	end
	
	#Actualise la case située aux coordonnées (x,y) Changer getCase dans le modèle
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
	
	def getCaseVue(unX, unY)
	
		return @mat[unX][unY]
	end
end
