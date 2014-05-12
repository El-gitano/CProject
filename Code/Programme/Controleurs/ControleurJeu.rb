#encoding: UTF-8

require './Modeles/ModeleJeu'
require './Vues/VueJeu'
require './Controleurs/Controleur'

require 'gtk2'

class ControleurJeu < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil, unChoix, unNom)

		super(unJeu)

		@modele = ModeleJeu.new(unProfil, unChoix, unNom)
		@vue = VueJeu.new(@modele)
		
		@modele.ajouterObservateur(@vue)
		
		#On connecte un signal à chaque bouton
		@vue.table.each{|uneCase|
		
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				# Si clic gauche
				if (event.button == 1) then
	
					puts "Clic gauche sur la case #{laCase.x}, #{laCase.y}"
					#@modele.plateauJeu
					
				# Si clic droit
				elsif (event.button == 3) then
		
					puts "Clic droit sur la case #{laCase.x}, #{laCase.y}"
				end
			}
		}
		
		#En cas de ragequit on met à jour le profil, on le sauvegarde et on quitte
		@vue.miRageQuit.signal_connect("activate"){
		
			@modele.ajouterRageQuit
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
		
		#Utilisation d'un joker
		@vue.btJoker.signal_connect("clicked"){
	
			#On dévoile les cases voulues
			@modele.utiliserJoker
		
			#On decremente le nb de jokers
			@modele.enleverJoker
		
			#On met jour la/les vues
			@modele.lancerMaj
		}
	
		#Utilisation d'un indice
		@vue.btIndice.signal_connect("clicked"){
	
			#On trouve la ligne/colonne où on peut avoir un indice
			indice = @modele.getIndice
		
			if !indice.nil? then
		
				DialogueInfo.afficher("Indice", "Vous pouvez jouer #{indice}")
		
			else
		
				DialogueInfo.afficher("Indice introuvable", "Nous n'avons aucun indice à vous donner")
			end
		}
		
		# Bouton pour vérifier si la grille est correctement remplie 
		@vue.btVerifier.signal_connect("clicked"){

			if @modele.plateau.estRempli? then
				dialogue = Gtk::Dialog.new("Fin de partie", @window, Gtk::Dialog::DESTROY_WITH_PARENT,["Nouvelle Partie", Gtk::Dialog::RESPONSE_ACCEPT],["Retour à l'accueil", Gtk::Dialog::RESPONSE_REJECT])
		
				# Creation des box
				hbox1 = Gtk::HBox.new(false, 5)	

				hbox2 = Gtk::HBox.new(false, 5)	
				vbox1 = Gtk::VBox.new(false, 5)
				vbox2 = Gtk::VBox.new(false, 5)

				# Creation des elements
				labelInfo = Gtk::Label.new("La grille est correcte ! \n")	
				labelClic = Gtk::Label.new("Nombre de clics : ")
				labelJoker = Gtk::Label.new("Nombre de jokers utilises : ")
				labelErreur = Gtk::Label.new("Nombre d'erreurs : ")
				labelTemps = Gtk::Label.new("Temps ecoule : ")

				labelNbClic = Gtk::Label.new("100")
				labelNbJoker = Gtk::Label.new("3")
				labelNbErreur = Gtk::Label.new("10")
				labelTempsEcoule = Gtk::Label.new("15:15 ")
		
				# Ajout des elements
				dialogue.vbox.add(hbox1)

				dialogue.vbox.add(hbox2)
					hbox2.add(vbox1)
					hbox2.add(vbox2)
				
				hbox1.add(labelInfo)

				vbox1.add(labelClic)
				vbox1.add(labelJoker)
				vbox1.add(labelErreur)
				vbox1.add(labelTemps)

				vbox2.add(labelNbClic)	
				vbox2.add(labelNbJoker)
				vbox2.add(labelNbErreur)		
				vbox2.add(labelTempsEcoule)

				# Affichage des elements et lancement de la fenetre
				dialogue.show_all

				dialogue.run{|reponse|
				
					if reponse == Gtk::Dialog::RESPONSE_ACCEPT then
						# Retour au menu de jeu
						changerControleur(ControleurMenuJeu.new(@picross, @modele.profil))

					else
						# Retour à l'accueil
						self.retourAccueil
					end			
				}

			else
				dialogue = Gtk::Dialog.new("Information", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
				labelInfo = Gtk::Label.new("La grille doit être remplie avant de pouvoir la vérifier.")

				dialogue.vbox.add(labelInfo)
				dialogue.show_all
				dialogue.run
			end
		}	

		# Sauvegarder la grille pour la continuer plus tard
		@vue.miSauvegarder.signal_connect("activate"){	
		
			i=1
		}
	end	
end
