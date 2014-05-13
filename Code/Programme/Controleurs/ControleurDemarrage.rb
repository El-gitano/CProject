# encoding: UTF-8

require_relative '../Modeles/ModeleDemarrage'
require_relative '../Vues/VueDemarrage'
require_relative 'Controleur'
require_relative 'ControleurAccueil'

require 'gtk2'

#Le contrôleur de démarrage permet de lancer le jeu en permettant à l'utilisateur de se connecter à son profil ou d'en créer un
class ControleurDemarrage < Controleur
	
	public_class_method :new
	
	def initialize(unJeu)
		
		super(unJeu)
		
		@modele = ModeleDemarrage.new
		@vue = VueDemarrage.new(@modele)	
		@modele.ajouterObservateur(@vue)
		
		#Handlers de signaux
		
		#Fin du programme
		@vue.window.signal_connect('delete_event'){
		
			Gtk.main_quit
		}
		
		@vue.boutonSupprimer.signal_connect("clicked"){
		
			pseudo = @vue.getProfil
			message = ""
			
			if @modele.existe?(pseudo) then
			
				dialogue = Gtk::Dialog.new("Supression du profil #{pseudo}", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
			
				hbox = Gtk::HBox.new(false, 5)
			
				label = Gtk::Label.new("Etes vous sûr de vouloir supprimer le profil #{pseudo} ?")
				image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
			
				hbox.pack_start(image, false, false, 0)
				hbox.pack_start(label, false, false, 0)
			
				dialogue.vbox.add(hbox)
			
				dialogue.show_all
			
				dialogue.run{|reponse|
			
					if reponse == Gtk::Dialog::RESPONSE_ACCEPT then

						if @modele.supprimerProfil(pseudo) then

							message = "Profil #{pseudo} supprimé avec succès !"	
						else 	
						
							message = "Impossible de supprimer le profil #{pseudo}"
						end
					end
				}
			
				dialogue.destroy
			
			else
			
				message = "Le profil #{pseudo} n'existe pas"
				print message
			end
			
			@vue.genererMessage(message)
			@vue.actualiser
		}
		
		@vue.boutonConnecter.signal_connect("clicked"){
			
			pseudo = @vue.getProfil
			
			if @modele.existe?(pseudo) then
			
				@vue.genererMessage("Connexion au profil #{pseudo}")
				@modele.chargerProfil(pseudo)
				changerControleur(ControleurAccueil.new(@picross, @modele.profil))
				
			else
			
				@vue.genererMessage("Le profil #{pseudo} n'existe pas")
			end
		}
		
		@vue.boutonAjouter.signal_connect("clicked"){
			
			nomProfil = @vue.getProfil
			
			if @modele.existe?(nomProfil) then
			
				message = "Le profil #{nomProfil} existe déjà !"
				
			elsif !nomProfil.eql?("") and @modele.creerProfil(nomProfil) then
			
				@vue.actualiser
				message = "Profil #{nomProfil} crée avec succès !"
				
				@vue.setProfil(nomProfil)
				
			else
			
				message = "Impossible de créer le profil #{nomProfil}"
			end
			
			@vue.genererMessage(message)
		}
	end
end
