#encoding: UTF-8
require 'gtk2'

require_relative 'DialogueConfirmation'

#DialogueSaveEditeur permet de lancer une boîte de dialogue invitant le joueur à rentrer un nom de sauvegarde pour la nouvelle grille de son éditeur 
class DialogueSaveEditeurExport < Gtk::Dialog

	@modele
	@etNomGrille
	
	private_class_method :new
	
	attr_reader :etNomGrille
	
	#Cette méthode crée le dialogue et le lance
	def DialogueSaveEditeurExport.afficher(uneFenetre, unModele)
	
		d = new(uneFenetre, unModele)
		d.show_all
		
		choix = false
		
		while choix != true
		
			d.run{|reponse|
		
				case reponse
				
					#L'utilisateur souhaite sauvegarder
					when Gtk::Dialog::RESPONSE_ACCEPT
						
						#Si la grille existe déjà on propose de l'écraser
						if unModele.grilleExiste?(d.etNomGrille.text) then
						
							choix = DialogueConfirmation.afficher("Export existant", uneFenetre, "Un export existe déjà sous ce nom. Écraser l'export existant ?")
							
							if choix then
							
								unModele.miseAJourGrille(d.etNomGrille.text)
								DialogueInfo.afficher("Sauvegarde de l'export", "Export sauvegardé avec succès\nL'ancien export a été écrasée", uneFenetre)
							end
						
						#On ajoute une nouvelle grille	
						else
						
							choix = true
							unModele.ajouterGrilleCree
							unModele.sauvegarderGrilleEditeur(d.etNomGrille.text)
							DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès", uneFenetre)
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
		
		lbNomGrille = Gtk::Label.new("Nom de la grille : ")
		@etNomGrille = Gtk::Entry.new
		@etNomGrille.text = unModele.grille.nomGrille
		
		hBox = Gtk::HBox.new(false, 5)

		hBox.pack_start(lbNomGrille , false, false, 0)
		hBox.pack_start(@etNomGrille , false, false, 0)
		vbox.pack_start(hBox, false, false, 0)
	end
end
