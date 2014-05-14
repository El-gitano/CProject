require 'gtk2'

require_relative 'DialogueConfirmation'

#DialogueSaveJeu permet de lancer une boîte de dialogue invitant le joueur à rentrer un nom de sauvegarde pour sa partie en cours
class DialogueSaveJeu < Gtk::Dialog

	@modele
	@etNomSauvegarde
	
	private_class_method :new
	
	attr_reader :etNomSauvegarde
	
	#Cette méthode crée le dialogue et le lance
	def DialogueSaveJeu.afficher(uneFenetre, unModele)
	
		d = new(uneFenetre, unModele)
		d.show_all
		
		choix = false
		
		while choix != true
		
			d.run{|reponse|
		
				case reponse
				
					#L'utilisateur souhaite sauvegarder
					when Gtk::Dialog::RESPONSE_ACCEPT
				
						#Si le nom de la sauvegarde n'est pas renseigné
						if d.etNomSauvegarde.text.eql?("") then 
					
							DialogueInfo.afficher("Pas de nom de sauvegarde", "Veuillez renseigner un nom de sauvegarde svp", uneFenetre)
						
						#Si la sauvegarde existe déjà on propose de l'écraser
						elsif unModele.sauvegardeExiste?(d.etNomSauvegarde.text) then
						
							choix = DialogueConfirmation.afficher("Sauveagrde existante", uneFenetre, "Une sauvegarde existe déjà sous ce nom. Écraser la sauvegarde existante ?")
							
							if choix then
							
								unModele.remplacerSauvegarde(d.etNomSauvegarde.text)
								DialogueInfo.afficher("Sauvegarde écrasée", "Sauvegarde effectuée avec succès\nL'ancienne sauvegarde a été écrasée", uneFenetre)
							end
						
						#On ajoute une nouvelle sauvegarde
						else
						
							choix = true
							unModele.nouvelleSauvegarde(d.etNomSauvegarde.text)
							DialogueInfo.afficher("Sauvegarde de la grille", "Sauvegarde effectuée avec succès", uneFenetre)
						end
				
					#L'utilisateur annule son action
					when Gtk::Dialog::RESPONSE_REJECT
				
						choix = true
				end
			}
		end
		
		d.destroy
	end
	
	def initialize(uneFenetre, unModele)
	
		super("Sauvegarde", uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		
		set_modal(true)
		
		lbNomGrille = Gtk::Label.new("Nom de la sauvegarde : ")
		@etNomSauvegarde = Gtk::Entry.new
		@etNomSauvegarde.text = unModele.grille.nomGrille
		
		hBox = Gtk::HBox.new(false, 5)

		hBox.pack_start(lbNomGrille , false, false, 0)
		hBox.pack_start(@etNomSauvegarde , false, false, 0)
		vbox.pack_start(hBox, false, false, 0)
	end
end
