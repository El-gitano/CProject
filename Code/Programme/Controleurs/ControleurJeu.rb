#encoding: UTF-8

require_relative '../Modeles/ModeleJeu'
require_relative '../Vues/VueJeu'
require_relative '../Vues/Dialogues/DialogueTuto'
require_relative '../Vues/Dialogues/DialogueInfoFinPartie'
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
		
		#Affichage du didacticiel et arrete le Timer pendant ce temps et le reprendre lorsqu'on le ferme
		@vue.miDidac.signal_connect("activate"){
			@modele.timer.stopperTimer
			DialogueTuto.afficher(@vue.window)
			@modele.timer.lancerTimer
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
		
		# Bouton pour vérifier si la grille est correctement remplie 
		@vue.btVerifier.signal_connect("clicked"){

			if @modele.grilleValide? then
				
				DialogueInfoFinPartie.afficher("Statistiques de fin de partie", @modele, @vue.window)

			else
				
				DialogueInfo.afficher("Grille invalide", "Votre grille est invalide", @vue.window)
			end
		}	

		# Sauvegarder la grille pour la continuer plus tard
		@vue.miSauvegarder.signal_connect("activate"){	
			@modele.timer.stopperTimer
			dgSauvegarde
			@modele.lancerMaj
			@modele.timer.lancerTimer
		}
		
		# On propose la sauvegarde avant de quitter la partie
		@vue.miQuitter.signal_connect("activate"){
			@modele.timer.stopperTimer
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
