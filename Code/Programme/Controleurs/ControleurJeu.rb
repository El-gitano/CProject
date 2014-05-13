#encoding: UTF-8

require_relative '../Modeles/ModeleJeu'
require_relative '../Vues/VueJeu'
require_relative 'Controleur'

require 'gtk2'

class ControleurJeu < Controleur

	@multiSelection
	@didacticiel
	
	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil, unChoix, unNom)

		super(unJeu)

		@modele = ModeleJeu.new(unProfil, unChoix, unNom)
		@vue = VueJeu.new(@modele)	
		@modele.ajouterObservateur(@vue)
		
		#On link le label au timer
		@modele.timer.label = @vue.lbTimer

		#Multi-sélection
		@vue.window.signal_connect("key-press-event"){|w, e|
		
			if  Gdk::Keyval::GDK_space == e.keyval then
			
				if @multiSelection then
				
					@multiSelection = false
					
				else
				
					@multiSelection = true
				end
			end
		}
		
		#On connecte un signal à chaque bouton
		@vue.table.each{|uneCase|
		
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				#Màj stats
				@modele.ajouterClic
				
				# Si clic gauche
				if (event.button == 1) then
	
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicGauche
					
				# Si clic droit
				elsif (event.button == 3) then
		
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicDroit		
				end
				
				@vue.actualiserCase(laCase.x, laCase.y)
			}
			
			uneCase.signal_connect("enter-notify-event"){|w, event|
			
				if @multiSelection then
				
					@modele.ajouterClic
					@modele.getCase(uneCase.x,  uneCase.y).clicGauche
					@modele.lancerMaj
				end
			}
		}
		
		#En cas de ragequit on met à jour le profil, on le sauvegarde et on quitte
		@vue.miRageQuit.signal_connect("activate"){
		
			@modele.ajouterRageQuit
			@modele.ajouterTemps
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
		
		#Utilisation d'un joker
		@vue.btJoker.signal_connect("clicked"){
	
			#On dévoile les cases voulues
			@modele.utiliserJoker
		
			#On met jour la/les vues
			@modele.lancerMaj
		}
	
		#Utilisation d'un indice
		@vue.btIndice.signal_connect("clicked"){
	
			#On trouve la ligne/colonne où on peut avoir un indice
			indice = @modele.getIndice
		
			if !indice.nil? then
		
				DialogueInfo.afficher("Indice", "Vous pouvez jouer #{indice}", @vue.window)
		
			else
		
				DialogueInfo.afficher("Indice introuvable", "Nous n'avons aucun indice à vous donner", @vue.window)
			end
		}
		
		# Bouton pour voir le didacticiel
		@vue.btDidacticiel.signal_connect("clicked"){
		
			dialogue = Gtk::Dialog.new("Didacticiel", @window, Gtk::Dialog::DESTROY_WITH_PARENT,["Valider", Gtk::Dialog::RESPONSE_ACCEPT])
			
			# Creation des elements
			lbDidac1 = Gtk::Label.new("But du jeu")
			lbDidac2 = Gtk::Label.new("Le but d'un hanjie est de noircir les cases de la grille afin de faire apparaître une image, un dessin. Les nombres à gauche et au-dessus de la grille sont là pour vous aider à déduire les cases à noircir.")
			
			lbDidac3 = Gtk::Label.new("Quelles sont les cases à noircir?")
			lbDidac4 = Gtk::Label.new("Les nombres présents à gauche de la grille indiquent le nombre de cases à noircir sur la ligne correspondante. Les nombres présents en haut de la grille indiquent le nombre de cases à noircir sur la colonne correspondante.")
			
			lbDidac5 = Gtk::Label.new("Pourquoi y-a-t-il plusieurs nombres?")
			lbDidac6 = Gtk::Label.new("Un nombre 5 devant une ligne (à gauche de la grille donc) indique que vous devez noircir cinq cases à la suite sur cette même ligne. La séquence 3 2 signifie qu'il y a au moins une case vide entre une séquence de trois cases à noircir et une autre séquence de deux cases à noircir. ")
			
			lbDidac7 = Gtk::Label.new("Les cases faciles à noircir")
			lbDidac8 = Gtk::Label.new("Il y a quelques astuces à connaitre afin de résoudre facilement un hanjie.Par exemple si le hanjie est une grille de 10 cases sur 10 cases, une colonne (ou une ligne) indiquant 10 signifie que toutes les cases de la colonne (ou de la ligne) doivent être noircies. Un autre exemple, si une ligne (ou une colonne) comporte 10 cases et que seules 7 cases sont à noircir, vous pouvez noircir les quatre cases centrales: ces cases seront noircies quelque soit la solution de cette ligne (ou de cette colonne). Cette astuce fonctionne dès qu'une ligne ou une colonne ne possède qu'un nombre et que ce nombre est strictement plus grand que la moitié des cases de cette ligne ou de cette colonne. ")
			
			lbDidac9 = Gtk::Label.new("Les cases à éliminer")
			lbDidac10 = Gtk::Label.new("Vous pouvez aussi éliminer les cases qui ne sont évidemment pas à noircir, cela permet de voir plus clair dans la résolution du hanjie.Par exemple si une ligne contient trois cases à noircir et que vous avez déjà noircies ces trois cases, vous pouvez éliminer toutes les autres cases de cette ligne. ")
	
			scrolled_window = Gtk::ScrolledWindow.new( nil, nil )
			scrolled_window.border_width = (10)
			scrolled_window.set_policy( Gtk::POLICY_AUTOMATIC, Gtk::POLICY_ALWAYS )

			# Ajout des elements
			dialogue.vbox.add(lbDidac1)
			dialogue.vbox.add(lbDidac2)			
			dialogue.vbox.add(lbDidac3)
			dialogue.vbox.add(lbDidac4)
			dialogue.vbox.add(lbDidac5)		
			dialogue.vbox.add(lbDidac6)   
			dialogue.vbox.add(lbDidac7)
			dialogue.vbox.add(lbDidac8)
			dialogue.vbox.add(lbDidac9)
			dialogue.vbox.add(lbDidac10)			
				
			dialogue.vbox.pack_start( scrolled_window, true, true, 0 )
					
			dialogue.show_all
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

				

			else
				
				DialogueInfo.afficher("Grille invalide", "Votre grille est invalide", @vue.window)
			end
		}	

		# Sauvegarder la grille pour la continuer plus tard
		@vue.miSauvegarder.signal_connect("activate"){	
		
			dgSauvegarde
			@modele.lancerMaj
		}
		
		# On propose la sauvegarde avant de quitter la partie
		@vue.miQuitter.signal_connect("activate"){
		
			dgSauvegardeQuitter
		}
		
		#On revient au menu quand la fenêtre de l'éditeur est fermée
		@vue.window.signal_connect('delete_event'){
		
			dgSauvegardeQuitter
		}
	end
	
	#Boite de dialogue récupérant la sauvegarde
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
			if reponse == Gtk::Dialog::RESPONSE_ACCEPT

					#On vérifie que la grille n'existe pas et que l'utilisateur est propriétaire de la grille
					if not etNomSauvegarde.text.eql?("") then
						
						#La grille existe déjà, on demande donc à l'utilisateur de confirmer sa sauvegarde
						if @modele.sauvegardeExiste?(etNomSauvegarde.text) then
					
							d = Gtk::Dialog.new("Sauvegarde existante", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
							d.set_modal(true)

							hbox = Gtk::HBox.new(false, 5)

							label = Gtk::Label.new("Une sauvegarde sous ce nom existe déjà. Écraser la sauvegarde existante ?")
							image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

							hbox.pack_start(image, false, false, 0)
							hbox.pack_start(label, false, false, 0)

							d.vbox.add(hbox)

							d.show_all	
							d.run{|reponse|
						
								case reponse
									
									#Réponse positive on sauvegarde en écrasant l'ancienne grille
									when Gtk::Dialog::RESPONSE_ACCEPT
										
										@modele.profil.getStats["timer"] += @modele.tempsEcoule
										@modele.remplacerSauvegarde
										DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès\nL'ancienne grille a été écrasée", @vue.window)
										choixOK = true
								end
							}
							d.destroy
						
						#Pas de grille déjà existante, on sauvegarde
						else
						
							@modele.profil.getStats["timer"] += @modele.tempsEcoule
							@modele.nouvelleSauvegarde(etNomSauvegarde.text)
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
	
	def dgSauvegardeQuitter
	
		dialogue = Gtk::Dialog.new("Proposition de sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Non", Gtk::Dialog::RESPONSE_REJECT], ["Oui", Gtk::Dialog::RESPONSE_ACCEPT])

		dialogue.set_modal(true)

		lbNomSauvegarde = Gtk::Label.new("Souhaitez vous sauvegarder votre grille avant de quitter ?")
		dialogue.vbox.pack_start(lbNomSauvegarde, false, false, 0)
	
		dialogue.show_all

		dialogue.run{|reponse|

			if reponse == Gtk::Dialog::RESPONSE_ACCEPT
			
				dgSauvegarde
			end
		}
		
		dialogue.destroy
		
		@modele.timer.stopperTimer
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
