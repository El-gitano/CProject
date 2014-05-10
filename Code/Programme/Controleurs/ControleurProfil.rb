# encoding: UTF-8

require './Modeles/ModeleProfil'
require './Vues/VueProfil'
require './Controleurs/Controleur'

require 'gtk2'

# Le contrôleur d'accueil permet d'accéder aux différents menu du jeu
class ControleurProfil < Controleur

	public_class_method :new

	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)
		@modele = ModeleProfil.new(unProfil)
		@vue = VueProfil.new(@modele)

		@modele.ajouterObservateur(@vue)	
		
		#On revient au menu quand la fenêtre des stats est fermée
		@vue.window.signal_connect('delete_event'){
		
			retourAccueil
		}
		
		#Réinitialisation des statistiques
		@vue.boutonEffacer.signal_connect("button_press_event"){
		
			@modele.reinitialiserStatistiques
		}
		
		#Renommage du profil
		@vue.boutonRenommer.signal_connect("button_press_event"){
			
			#On demande à l'utilisateur d'entrer un nouveau pseudo
			dialogue = Gtk::Dialog.new("Changement de pseudo", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])

			dialogue.set_modal(true)

			lbNomGrille = Gtk::Label.new("Nouveau pseudo : ")
			etNouveauPseudo = Gtk::Entry.new
			etNouveauPseudo.text = @modele.profil.pseudo
			
			hBox = Gtk::HBox.new(false, 5)

			hBox.pack_start(lbNomGrille , false, false, 0)
			hBox.pack_start(etNouveauPseudo , false, false, 0)
			dialogue.vbox.pack_start(hBox, false, false, 0)
			
			dialogue.show_all
			
			choixOK = false
			
			while choixOK != true
			
				dialogue.run{|reponse|

					#On ne traite la réponse que si l'utilisateur a cliqué sur "Enregistrer" ou "ANNULER"
					case reponse
	
						when Gtk::Dialog::RESPONSE_ACCEPT
		
							#On vérifie que la grille n'existe pas
							if not etNouveauPseudo.text.eql?("") then
								
								#Le profil existe déjà
								if @modele.profilExiste?(etNouveauPseudo.text) then
							
									DialogueInfo.afficher("Profil existant", "Ce profil existe déjà", @vue.window)
									
								#Le profil n'existe pas
								else
								
									@modele.changerNomProfil(etNouveauPseudo.text)
									 DialogueInfo.afficher("Changement profil", "Nom de profil changé avec succès !", @vue.window)
									choixOK = true
								end
							else
							
								 DialogueInfo.afficher("Profil non renseignée", "Veuillez renseigner un nom de profil s'il vous plaît", @vue.window)
							end
						
						when Gtk::Dialog::RESPONSE_REJECT
						
							choixOK = true
					end
				}				
			end
			
			dialogue.destroy
		}
	end
	
	# Retour a l'accueil
	def retourAccueil
	
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
