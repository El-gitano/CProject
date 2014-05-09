# encoding: utf-8

require './Modeles/ModeleEditeur'
require './Modeles/Grilles/GrilleEditeur'
require './Vues/VueEditeur'
require './Vues/DialogueInfo'
require 'gtk2'

class ControleurEditeur < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil, 10)
		@vue = VueEditeur.new(@modele)
		@modele.ajouterObservateur(@vue)
		
		#On revient au menu quand la fenêtre de l'éditeur est fermée
		@vue.window.signal_connect('delete_event'){
		
			retourAccueil
		}
		
		choixGrille = nil
		
		#Boîte de dialogue pour ouverture d'une grille
		@vue.boutonOuvrir.signal_connect("clicked"){
		
			dialogue = Gtk::Dialog.new("Ouverture d'un plateau", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

			dialogue.set_size_request(550,200)
			dialogue.set_modal(true)

			comboBoxGrilles = Gtk::ComboBox.new(true)
	
			@modele.listeNomGrillesEditables(@modele.profil.pseudo){|x|

				comboBoxGrilles.append_text(x)
			}

			ligneH = Gtk::HSeparator.new

			lbNomGrille = Gtk::Label.new
			lbNomGrille.markup="<b>Le nom du plateau</b>"

			vBox = Gtk::VBox.new(false, 5)

			#Création de l'intérieur de la boite de dialogue
			lbNbJoker = Gtk::Label.new("Jokers : ")
			lbTaille = Gtk::Label.new("Taille : ")
			lbDateCreation = Gtk::Label.new("Date de création : ")
			lbDateModification = Gtk::Label.new("Date de modification : ")

			vBox.pack_start(lbNbJoker, false, false, 0)
			vBox.pack_start(lbTaille, false, false, 0)
			vBox.pack_start(lbDateCreation, false, false, 0)
			vBox.pack_start(lbDateModification, false, false, 0)

			#Ajout à la vbox par défaut
			dialogue.vbox.pack_start(comboBoxGrilles, false, false, 0)
			dialogue.vbox.pack_start(lbNomGrille, false, false, 0)
			dialogue.vbox.pack_start(vBox, false, false, 0)

			#Màj sélection de l'utilisateur
			comboBoxGrilles.signal_connect("changed"){

				nomGrille = comboBoxGrilles.active_text
				choixGrille = comboBoxGrilles.active_text
				lbNomGrille.markup = "<b>"+nomGrille+"</b>"
				grille = @modele.getGrille(nomGrille)
	
				lbNbJoker.text = "Jokers : " + grille.nbJokers.to_s
				lbTaille.text = "Taille : " + grille.taille.to_s + "X" + grille.taille.to_s
				lbDateCreation.text = "Date de création : " + grille.dateCreation.to_s
				lbDateModification.text = "Date de modification : " + grille.dateModification.to_s
			}

			dialogue.show_all

			dialogue.run{|reponse|

				#On ne traite la réponse que si l'utilisateur a cliqué sur "OPEN"
				case reponse
	
					when Gtk::Dialog::RESPONSE_ACCEPT
		
						@modele.charger(choixGrille)
	
				end
			}

			dialogue.destroy
			
			@modele.lancerMaj
			connecterGrille
		}
	
		#Dialogue pour l'enregistrement d'une grille
		@vue.boutonEnregistrer.signal_connect("clicked"){
	
			#On demande à l'utilisateur d'entrer un nom de grille
			dialogue = Gtk::Dialog.new("Nom de sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

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
		
							#On vérifie que la grille n'existe pas
							if not etNomGrille.text.eql?("") then
								
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
							
								 DialogueInfo.afficher("Grille non renseignée", "Veuillez renseigner un nom de grille s'il vous plaît", @vue.window)
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
	
		#Changement de la taille de la grille
		@vue.listBoutonTaille.each{|x|
		
			x.signal_connect("clicked"){|leBouton|

				@modele.grille = GrilleEditeur.Creer(leBouton.taille, "NouvelleGrille", @modele.profil, 0)
				@modele.lancerMaj
				connecterGrille
			}
		}
		
		connecterGrille
		
	end
	
	#Connecte un listener d'évènement sur la grille pour récupérer les clics
	def connecterGrille
	
		#On connecte un signal pour chaque case du plateau
		@vue.operationGrille{|uneCase|
		
			uneCase.signal_connect("button_press_event"){
				
				@modele.getCase(uneCase.x,  uneCase.y).clicGauche
				@modele.lancerMaj
			}
		}
	end
	
	# Retour a l'accueil
	def retourAccueil
	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
