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
		
		#On link le label au timer
		@modele.timer.label = @vue.lbTimer

		#On connecte un signal à chaque bouton
		@vue.table.each{|uneCase|
		
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				# Si clic gauche
				if (event.button == 1) then
	
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicGauche
					
				# Si clic droit
				elsif (event.button == 3) then
		
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicDroit		
				end
				
				@vue.actualiserCase(laCase.x, laCase.y)
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

			if @modele.grilleValide? then
				
				dialogue = Gtk::Dialog.new("Fin de partie", @window, Gtk::Dialog::DESTROY_WITH_PARENT,["Nouvelle Partie", Gtk::Dialog::RESPONSE_ACCEPT],["Retour à l'accueil", Gtk::Dialog::RESPONSE_REJECT])
		
				# Creation des box
				hbox1 = Gtk::HBox.new(false, 5)	

				hbox2 = Gtk::HBox.new(false, 5)	
				vbox1 = Gtk::VBox.new(false, 5)
				vbox2 = Gtk::VBox.new(false, 5)

				# Creation des elements
				labelInfo = Gtk::Label.new("La grille est valide ! \n")	
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
				
				DialogueInfo.afficher("Grille invalide", "Votre grille est invalide", @vue.window)
			end
		}	

		# Sauvegarder la grille pour la continuer plus tard
		@vue.miSauvegarder.signal_connect("activate"){	
		
			dgSauvegarde
		}
		
		@vue.miQuitter.signal_connect("activate"){#Ajouter vérification de sauvegarde
		
			changerControleur(ControleurAccueil.new(@picross, @modele.profil))
		}
	end
	
	def dgSauvegarde
	
		#On demande à l'utilisateur d'entrer un nom de grille
		dialogue = Gtk::Dialog.new("Nom de sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])

		dialogue.set_modal(true)

		lbNomSauvegarde = Gtk::Label.new("Nom de la sauvegarde : ")
		etNomSauvegarde = Gtk::Entry.new
		etNomSauvegarde.text = @modele.plateauJeu.nomGrille
		
		hBox = Gtk::HBox.new(false, 5)

		hBox.pack_start(lbNomSauvegarde , false, false, 0)
		hBox.pack_start(etNomSauvegarde , false, false, 0)
		dialogue.vbox.pack_start(hBox, false, false, 0)
		
		dialogue.show_all

		dialogue.run{|reponse|

			#On ne traite la réponse que si l'utilisateur a cliqué sur "Enregistrer" ou "ANNULER"
			if reponse.eql?(Gtk::Dialog::RESPONSE_ACCEPT)

					#On vérifie que la grille n'existe pas et que l'utilisateur est propriétaire de la grille
					if not etNomSauvegarde.text.eql?("") then
						
						#La grille existe déjà, on demande donc à l'utilisateur de confirmer sa sauvegarde
						if @modele.sauvegardeExiste?(etNomSauvegarde.text) then
					
							d = Gtk::Dialog.new("Sauvegarde existante", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
							d.set_modal(true)

							hbox = Gtk::HBox.new(false, 5)

							label = Gtk::Label.new("Une sauvegarde sous ce nom existe déjà. Écraser la grille existante ?")
							image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

							hbox.pack_start(image, false, false, 0)
							hbox.pack_start(label, false, false, 0)

							d.vbox.add(hbox)

							d.show_all	
							d.run{|reponse|
						
								case reponse
									
									#Réponse positive on sauvegarde en écrasant l'ancienne grille
									when Gtk::Dialog::RESPONSE_ACCEPT
								
										@modele.remplacerSauvegarde
										DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès\nL'ancienne grille a été écrasée", @vue.window)
										choixOK = true
								end
							}
							d.destroy
						
						#Pas de grille déjà existante, on sauvegarde
						else
						
							@modele.sauvegarderGrille(etNomGrille.text)
							 DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès", @vue.window)
							choixOK = true
						end
					else
					
						 DialogueInfo.afficher("Grille non renseignée", "Grille appartenant à un autre joueur ou non renseignée", @vue.window)
					end
			end
		}
		
		dialogue.destroy
	end
end
