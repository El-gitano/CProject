# encoding: utf-8

require_relative 'Controleur'
require_relative 'ControleurOuvrirGrille'

require_relative '../Modeles/ModeleEditeur'
require_relative '../Modeles/Grilles/GrilleEditeur'

require_relative '../Vues/VueEditeur'
require_relative '../Vues/Dialogues/DialogueInfo'

require 'gtk2'

class ControleurEditeur < Controleur

	public_class_method :new
	
	@multiSelection = false
	
	# Constructeur
	def initialize(unJeu, unProfil, grilleACharger = nil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil, 10)
		@vue = VueEditeur.new(@modele)
		@modele.ajouterObservateur(@vue)	
		@modele.charger(grilleACharger) if !grilleACharger.nil?
		
		#On revient au menu quand la fenêtre de l'éditeur est fermée
		@vue.window.signal_connect('delete_event'){
		
			@modele.sauvegarderProfil
			Gtk.main_quit
		}
		
		choixGrille = nil
		
		#Boîte de dialogue pour ouverture d'une grille
		@vue.boutonOuvrir.signal_connect("clicked"){

			changerControleur(ControleurOuvrirGrille.new(@picross, @modele.profil))
		}
	
		#Dialogue pour l'enregistrement d'une grille
		@vue.boutonEnregistrer.signal_connect("clicked"){
	
			#On demande à l'utilisateur d'entrer un nom de grille
			dialogue = Gtk::Dialog.new("Sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

			dialogue.set_modal(true)

			lbNomGrille = Gtk::Label.new("Nom de la grille : ")
			etNomGrille = Gtk::Entry.new
			etNomGrille.text = @modele.grille.nomGrille
			
			hBox = Gtk::HBox.new(false, 5)

			hBox.pack_start(lbNomGrille , false, false, 0)
			hBox.pack_start(etNomGrille , false, false, 0)
			dialogue.vbox.pack_start(hBox, false, false, 0)
			
			etNomGrille.signal_connect("changed"){
			
				@modele.grille.nomGrille = etNomGrille.text
			}
			
			dialogue.show_all
			
			choixOK = false
			
			while choixOK != true
			
				dialogue.run{|reponse|

					#On ne traite la réponse que si l'utilisateur a cliqué sur "Enregistrer" ou "ANNULER"
					case reponse
	
						when Gtk::Dialog::RESPONSE_ACCEPT
		
							#On vérifie que la grille n'existe pas et que l'utilisateur est propriétaire de la grille
							if not etNomGrille.text.eql?("") and @modele.grillePropriete(etNomGrille.text) then
								
								#La grille existe déjà, on demande donc à l'utilisateur de confirmer sa sauvegarde
								if @modele.grilleExiste?(etNomGrille.text) then
							
									d = Gtk::Dialog.new("Grille existante", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])
									d.set_modal(true)

									hbox = Gtk::HBox.new(false, 5)

									label = Gtk::Label.new("Une grille sous ce nom existe déjà. Écraser la grille existante ?")
									image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

									hbox.pack_start(image, false, false, 0)
									hbox.pack_start(label, false, false, 0)

									d.vbox.add(hbox)

									d.show_all	
									d.run{|reponse|
								
										case reponse
											
											#Réponse positive on sauvegarde en écrasant l'ancienne grille
											when Gtk::Dialog::RESPONSE_ACCEPT
										
												@modele.miseAJourGrille(etNomGrille.text)
												@modele.ajouterGrilleCree
												DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès\nL'ancienne grille a été écrasée", @vue.window)
												choixOK = true
										end
									}
									d.destroy
								
								#Pas de grille déjà existante, on sauvegarde
								else
								
									@modele.ajouterGrilleCree
									@modele.sauvegarderGrille(etNomGrille.text)
									DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès", @vue.window)
									choixOK = true
								end
							else
							
								 DialogueInfo.afficher("Grille non renseignée", "Grille appartenant à un autre joueur ou non renseignée", @vue.window)
							end
						
						when Gtk::Dialog::RESPONSE_REJECT
						
							choixOK = true
					end
				}
			end
			dialogue.destroy
		}
	
		#Génération d'un grille aléatoire
		@vue.boutonAleatoire.signal_connect("clicked"){
	
			@modele.grille.genererAleatoire
			@modele.lancerMaj
		}

		# Bouton pour le retour a l'accueil	
		@vue.boutonRetour.signal_connect("clicked"){
			retourAccueil
		}

		#Le SpinButton des jokers
		@vue.sbNbJokers.signal_connect("value-changed"){
		
			@modele.setNbJokers(@vue.sbNbJokers.value)
		}
		
		#Changement de la taille de la grille
		@vue.listBoutonTaille.each{|x|
		
			x.signal_connect("clicked"){|leBouton|

				@modele.grille = GrilleEditeur.Creer(leBouton.taille, "NouvelleGrille", @modele.profil, 0)
				@modele.lancerMaj
				connecterGrille
			}
		}
		
		connecterGrille
		@modele.lancerMaj
		
	end
	
	#Connecte un listener d'évènement sur chaque case de la grille pour récupérer les clics
	def connecterGrille
	
		#On connecte un signal pour chaque case du plateau
		@vue.operationGrille{|uneCase|
		
			uneCase.signal_connect("button_press_event"){

				@modele.getCase(uneCase.x,  uneCase.y).clicGauche
				@modele.lancerMaj
			}
		}

	end
	
	# Retour à l'accueil
	def retourAccueil
	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
