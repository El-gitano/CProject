# encoding: UTF-8

require_relative '../Modeles/ModeleDemarrage'

require_relative '../Vues/VueDemarrage'
require_relative '../Vues/Dialogues/DialogueInfo'
require_relative '../Vues/Dialogues/DialogueSupprimerProfil'

require_relative 'Controleur'
require_relative 'ControleurAccueil'

require 'gtk2'

#Le contrôleur de démarrage permet de lancer le jeu en permettant à l'utilisateur de se connecter à son profil ou d'en créer un
class ControleurDemarrage < Controleur
	
	private_class_method :new
	
	def initialize(unJeu)
		
		super(unJeu)
		
		@modele = ModeleDemarrage.new
		@vue = VueDemarrage.new(@modele)	
		@modele.ajouterObservateur(@vue)

		@nbCaracteres
		@taillePseudo = 7
		
		#Handlers de signaux
		
		#Fin du programme
		@vue.window.signal_connect('delete_event'){
		
			quitterJeu
		}
		
		@vue.boutonSupprimer.signal_connect("clicked"){
		
			pseudo = @vue.getProfil
			
			if @modele.existeProfil?(pseudo) and !pseudo.eql?("Route") then 
			
				@modele.supprimerProfil(pseudo) if DialogueSupprimerProfil.afficher(@vue.window, pseudo)

			else
			
				DialogueInfo.afficher("Profil inexistant", "Le profil #{pseudo} n'existe pas", @vue.window)
			end
				
			@vue.actualiser
		}
		
		@vue.boutonConnecter.signal_connect("clicked"){
			
			pseudo = @vue.getProfil
			
			if @modele.existeProfil?(pseudo) and !pseudo.eql?("Route") then
			
				@vue.genererMessage("Connexion au profil #{pseudo}")
				@modele.chargerProfil(pseudo)
				changerControleur(ControleurAccueil.new(@picross, @modele.profil))
				
			else
			
				DialogueInfo.afficher("Profil inexistant", "Le profil #{pseudo} n'existe pas", @vue.window)
			end
		}
		
		@vue.boutonAjouter.signal_connect("clicked"){
			
			nomProfil = @vue.getProfil
			@nbCaracteres = nomProfil.length
			
			if nomProfil.eql?("") then
			
				DialogueInfo.afficher("Pseudo non renseigné", "Vous n'avez pas renseigné de pseudo", @vue.window)

			elsif @nbCaracteres > @taillePseudo then

				DialogueInfo.afficher("Pseudo trop long", "Le pseudo ne doit pas depasser #@taillePseudo caracteres", @vue.window)

			elsif @modele.existeProfil?(nomProfil)
			
				DialogueInfo.afficher("Profil existant", "Le profil que vous souhaitez créer existe déjà", @vue.window)
			else
			
				@modele.creerProfil(nomProfil)
				@vue.actualiser
				DialogueInfo.afficher("Création de profil", "Le profil #{nomProfil} a été crée avec succès !", @vue.window)
			end
		}
	end
end
