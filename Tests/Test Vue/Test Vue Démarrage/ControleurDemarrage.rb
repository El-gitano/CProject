require './ModeleDemarrage'
require './VueDemarrage'
require './Controleur'

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
		
		@vue.boutonSupprimer.signal_connect("clicked"){
		
			pseudo = @vue.getProfil
			message = ""
			
			if @modele.existe?(pseudo) then
			
				dialogue = Gtk::Dialog.new("Supression du profil #{pseudo}", @vue.window, Gtk::Dialog::DESTROY_WITH_PARENT,  [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT], [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT])
			
				hbox = Gtk::HBox.new(false, 5)
			
				label = Gtk::Label.new("Etes vous sur de vouloir supprimer le profil #{pseudo} ?")
				image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
			
				hbox.pack_start(image, false, false, 0)
				hbox.pack_start(label, false, false, 0)
			
				dialogue.vbox.add(hbox)
			
				dialogue.show_all
			
				dialogue.run{|reponse|
			
					if reponse == Gtk::Dialog::RESPONSE_ACCEPT then

						if @modele.supprimerProfil(pseudo) then

							message = "Profil #{pseudo} supprime avec succes !"	
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
				#Changer de contrôleur pour le jeu
				
			else
			
				@vue.genererMessage("Le profil #{pseudo} n'existe pas")
			end
		}
		
		@vue.boutonAjouter.signal_connect("clicked"){
			
			nomProfil = @vue.getProfil
			
			if @modele.existe?(nomProfil) then
			
				message = "Le profil #{nomProfil} existe deja !"
				
			elsif !nomProfil.eql?("") and @modele.creerProfil(nomProfil) then
			
				@vue.actualiser
				message = "Profil #{nomProfil} cree avec succes !"
				
				@vue.setProfil(nomProfil)
				
			else
			
				message = "Impossible de creer le profil #{nomProfil}"
			end
			
			@vue.genererMessage(message)
		}
	end
end
