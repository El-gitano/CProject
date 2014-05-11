#encoding: UTF-8

require './Modeles/ModeleAccueil'
require './Vues/VueAccueil'
require './Controleurs/Controleur'
require './Controleurs/ControleurEditeur'
require './Controleurs/ControleurProfil'
require './Controleurs/ControleurJeu'

require 'gtk2'

# Le contrôleur d'accueil permet d'accéder aux différents menu du jeu
class ControleurAccueil < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleAccueil.new(unProfil)
		@vue = VueAccueil.new(@modele)

		@modele.ajouterObservateur(@vue)	
		
		#On revient au menu quand la fenêtre de l'accueil est fermée
		@vue.window.signal_connect('delete_event'){
		
			@modele.sauvegarderProfil
			changerControleur(ControleurDemarrage.new(@picross))
		}
		
		#Retour à l'accueil
		@vue.boutonDeco.signal_connect("clicked"){
	
			@modele.sauvegarderProfil
			changerControleur(ControleurDemarrage.new(@picross))
		}
	
		#Lancement d'une partie (après sélection de la grille)
		@vue.boutonJouer.signal_connect("clicked"){
	
			nomGrille = dgBoxChoixPartie
			changerControleur(ControleurJeu.new(@picross, @modele.profil, nomGrille)) if !nomGrille.nil?
		}
	
		#Lancement de l'éditeur
		@vue.boutonEditer.signal_connect("clicked"){
	
			changerControleur(ControleurEditeur.new(@picross, @modele.profil))
		}
	
		#Affichage des crédits
		@vue.boutonCredit.signal_connect("clicked"){
		
			dialogue = Gtk::Dialog.new("Crédits", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,[Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		
			# Creation des elements
			tabNoms = Array.new

			tabNoms.push(hBoxNom("AYDIN Emre"))
			tabNoms.push(hBoxNom("FOUCAULT Antoine"))
			tabNoms.push(hBoxNom("GUENVER Loic"))
			tabNoms.push(hBoxNom("LANVIN Elyan"))
			tabNoms.push(hBoxNom("MARCAIS Thomas"))
			tabNoms.push(hBoxNom("RAMOLET Arthur"))

			labelAnnee = Gtk::Label.new("\nCrée en 2014")
			labelUniv = Gtk::Label.new("Projet Université du Maine")

			# Ajout des elements a la Vbox
			tabNoms.each{|x|

				dialogue.vbox.add(x)
			}

			dialogue.vbox.add(labelAnnee)
			dialogue.vbox.add(labelUniv)

			# Affichage des elements et lancement de la fenetre
			dialogue.show_all

			dialogue.run
			
			dialogue.destroy
		}
	
		@vue.boutonProfil.signal_connect("clicked"){

			changerControleur(ControleurProfil.new(@picross, @modele.profil))
		}
	end
	
	#Crée une Hbox à partir d'un nom qu'elle entoure d'étoiles
	def hBoxNom(unNom)
	
		hBox = Gtk::HBox.new(false, 5)
		imEtoile = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		imEtoile2 = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		
		hBox.pack_start(imEtoile, false, false, 0)
		hBox.pack_start(Gtk::Label.new(unNom))
		hBox.pack_start(imEtoile2, false, false, 0)
		
		return hBox
	end
	
	#Ouvre une boite de dialogue permettant au joueur de choisir entre charger une partie ou en créer une nouvelle
	def dgBoxChoixPartie
	
		dialogue = Gtk::Dialog.new("Choix de jeu", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Charger", 1], ["Nouvelle partie", 2])

		dialogue.set_modal(true)

		dialogue.show_all
		
		dialogue.run{|reponse|

			dialogue.destroy
			
			case reponse

				when 1#Chargement

					return dgBoxChargement
					
				when 2#Nouvelle partie

					return dgBoxNouvellePartie
					
				else

					return nil	
			end
		}
	end
	
	#Propose au joueur l'ensemble de ses sauvegardes
	def dgBoxChargement
	
		dialogue = Gtk::Dialog.new("Chargement d'une sauvegarde", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Annuler", 1], ["Charger", 2])

		dialogue.set_modal(true)

		comboBoxSauvegardes = Gtk::ComboBox.new(true)
		@modele.listeSauvegardes.each{|x|

			comboBoxGrilles.append_text(x)
		}

		dialogue.vbox.add(comboBoxSauvegardes)

		dialogue.show_all
		
		dialogue.run{|reponse|

			dialogue.destroy
			
			case reponse
			
				#Annulation
				when 1
				
					return nil
				
				#Chargement
				when 2
			
					return comboBoxSauvegardes.active_text.split#À compléter
					
				else
				
					return nil
			end
		}
	end
	
	#Propose au joueur l'ensemble des grilles jouables
	def dgBoxNouvellePartie
	
		dialogue = Gtk::Dialog.new("Nouvelle partie", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, ["Annuler", 1], ["Nouveau", 2])

		dialogue.set_modal(true)

		comboBoxGrilles = Gtk::ComboBox.new(true)
	
		@modele.listeGrilles.each{|x|

			comboBoxGrilles.append_text(x)
		}

		ligneH = Gtk::HSeparator.new

		lbNomGrille = Gtk::Label.new
		lbNomGrille.markup="<b>Le nom du plateau</b>"

		vBox = Gtk::VBox.new(false, 5)

		#Création de l'intérieur de la boite de dialogue
		lbCreateur = Gtk::Label.new
		lbNbJokers = Gtk::Label.new
		lbTaille = Gtk::Label.new
		lbDateCreation = Gtk::Label.new
		lbDateModification = Gtk::Label.new
		
		vBox.pack_start(creerHBox("Créateur", lbCreateur), false, false, 0)
		vBox.pack_start(creerHBox("Nombre de jokers", lbNbJokers), false, false, 0)
		vBox.pack_start(creerHBox("Taille", lbTaille), false, false, 0)
		vBox.pack_start(creerHBox("Date de création", lbDateCreation), false, false, 0)
		vBox.pack_start(creerHBox("Date de modification", lbDateModification), false, false, 0)

		#Ajout à la vbox par défaut
		dialogue.vbox.pack_start(comboBoxGrilles, false, false, 0)
		dialogue.vbox.pack_start(lbNomGrille, false, false, 0)
		dialogue.vbox.pack_start(vBox, false, false, 0)

		#Màj sélection de l'utilisateur
		comboBoxGrilles.signal_connect("changed"){

			nomGrille = comboBoxGrilles.active_text
			lbNomGrille.markup = "<b>"+nomGrille+"</b>"
			infos = @modele.getInfosGrille(nomGrille)

			lbCreateur.text = infos["createur"]
			lbNbJokers.text = infos["nbjokers"].to_s
			lbTaille.text = infos["taillegrille"].to_s + "X" + infos["taillegrille"].to_s
			lbDateCreation.text = infos["datecreation"].to_s
			lbDateModification.text = infos["datemaj"].to_s
		}
		
		dialogue.show_all	
		
		dialogue.run{|reponse|

			case reponse

				#Nouvelle partie
				when 2
					nomGrille = comboBoxGrilles.active_text
					dialogue.destroy
					return nomGrille
				
				#Annulation/Fermeture de la boîte	
				else 
					dialogue.destroy
					return nil
			end
		}
	end
	
	def creerHBox(unTitre, unLabel)
	
		hBox = Gtk::HBox.new(true, 5)
		
		hBox.pack_start(Gtk::Label.new(unTitre + " : "))
		hBox.pack_start(unLabel)
		return hBox
	end
end
