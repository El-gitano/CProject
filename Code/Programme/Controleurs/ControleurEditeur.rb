# encoding: utf-8

require './Modeles/Grilles/GrilleEditeur'
require 'gtk2'

class ControleurEditeur < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil)
		@vue = VueDemarrage.new(@modele)
		
		@modele.ajouterObservateur(@vue)
		
		choixGrille = nil
		
		#Boîte de dialogue pour ouverture d'une grille
		@vue.boutonOuvrir.signal_connect("clicked"){
		
			dialogue = Gtk::Dialog.new("Ouverture d'un plateau", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OPEN, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])

			dialogue.set_size_request(550,200)
			dialogue.set_modal(true)

			comboBoxGrilles = Gtk::ComboBox.new(true)
	
			@modele.listeGrillesEditables(@modele.profil.pseudo){|x|

				comboBoxGrilles.append_text(x.nom)
			}

			ligneH = Gtk::HSeparator.new

			lbNomGrille = Gtk::Label.new("Le nom du plateau")

			hBox = Gtk::HBox.new(false, 5)

			#Création de l'intérieur de la boite de dialogue
			lbNbJoker = Gtk::Label.new("Jokers : ")
			lbTaille = Gtk::Label.new("Taille : ")
			lbDateCreation = Gtk::Label.new("Date de création : ")

			hBox.pack_start(lbNbJoker, false, false, 0)
			hBox.pack_start(lbTaille, false, false, 0)
			hBox.pack_start(lbDateCreation, false, false, 0)

			#Ajout à la vbox par défaut
			dialogue.vbox.pack_start(comboBoxGrilles, false, false, 0)
			dialogue.vbox.pack_start(nomGrille, false, false, 0)
			dialogue.vbox.pack_start(hBox, false, false, 0)

			comboBoxGrilles.signal_connect("changed"){

				nomGrille = comboBoxGrilles.active_text
				choixGrille = comboBoxGrilles.active_text
				lbNomGrille.text = nomGrille
				grille = @modele.getGrille(nomGrille)
	
				lbNbJokers.text = grille.jokers
				lbTaille.text = grille.taille.to_s + "X" + grille.taille.to_s
				lbDateCreation = grille.dateCreation
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
		}
	
		@vue.boutonEnregistrer.signal_connect("clicked"){
	
			#On demande à l'utilisateur d'entrer un nom de grille
			Gtk::Dialog.new("Nom de sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])

			dialogue.set_modal(true)

			lbNomGrille = Gtk::Label.new("Nom de la grille : ")
			etNomGrille = Gtk::Entry.new
			
			hBox = Gtk::HBox.new(false, 5)

			hBox.pack_start(lbNomGrille , false, false, 0)
			hBox.pack_start(etNomGrille , false, false, 0)
			dialogue.vbox.pack_start(hBox, false, false, 0)
			
			nomGrille = nil
			
			etNomGrille.signal_connect("changed"){
			
				nomGrille = etNomGrille.text
			}
			
			#On vérifie que la grille n'existe pas
			if !nomGrille.eql?("") and @modele.grilleExiste?(nomGrille) then
			
				if @modele.enregistrerGrille(nomGrille) then
		
					dialogue = Gtk::Dialog.new("Sauvegarde de la grille", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
					dialogue.set_modal(true)
				
					hbox = Gtk::HBox.new(false, 5)
			
					label = Gtk::Label.new("Grille sauvegardée avec succès")
					image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
	
					hbox.pack_start(image, false, false, 0)
					hbox.pack_start(label, false, false, 0)
	
					dialogue.vbox.add(hbox)
	
					dialogue.show_all	
					dialogue.run
			
					dialogue.destroy
		
				else
		
					print "Erreur dans la sauvegarde de la grille"
					exit(-1)
				end
			
			else
				dialogue = Gtk::Dialog.new("Grille existante", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
				dialogue.set_modal(true)
			
				hbox = Gtk::HBox.new(false, 5)
		
				label = Gtk::Label.new("La grille " + nomGrille + " existe déjà !")
				image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

				hbox.pack_start(image, false, false, 0)
				hbox.pack_start(label, false, false, 0)

				dialogue.vbox.add(hbox)

				dialogue.show_all	
				dialogue.run
		
				dialogue.destroy
			end	
		}
	
		@vue.boutonAleatoire.signal_connect("clicked"){
	
			@modele.grille.genererAleatoire
			@modele.lancerMaj
		}
	
		@vue.listBoutonTaille.each{|x|
		
			x.signal_connect("clicked"){|leBouton|

				@modele.grille = GrilleEditeur.creerGrille(leBouton.taille)
				@modele.lancerMaj
			}
		}
		
		@modele.lancerMaj
	end
	
	# Retour a l'accueil
	def retourAccueil
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
