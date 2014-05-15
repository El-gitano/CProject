#encoding: UTF-8
require 'gtk2'

require_relative 'DialogueConfirmation'

#DialogueSaveEditeur permet de lancer une boîte de dialogue invitant le joueur à rentrer un nom de sauvegarde pour la nouvelle grille de son éditeur 
class DialogueSaveEditeur < Gtk::Dialog

	@modele
	@etNomGrille
	
	private_class_method :new
	
	attr_reader :etNomGrille
	
	#Cette méthode crée le dialogue et le lance
	def DialogueSaveEditeur.afficher(uneFenetre, unModele)
	
		d = new(uneFenetre, unModele)
		d.show_all
		
		choix = false
		
		while choix != true
		
			d.run{|reponse|
		
				case reponse
				
					#L'utilisateur souhaite sauvegarder
					when Gtk::Dialog::RESPONSE_ACCEPT
				
						#Si le nom de grille n'est pas renseigné
						if d.etNomGrille.text.eql?("") then 
					
							DialogueInfo.afficher("Pas de nom de grille", "Veuillez renseigner un nom de grille svp", uneFenetre)
						#Si le joueur n'est pas propriétaire de la grille
						elsif !unModele.grillePropriete?(d.etNomGrille.text) then
					
							DialogueInfo.afficher("Accès interdit", "La grille que vous essayez d'écraser ne vous appartient pas", uneFenetre)
						
						#Si la grille existe déjà on propose de l'écraser
						elsif unModele.grilleExiste?(d.etNomGrille.text) then
						
							choix = DialogueConfirmation.afficher("Grille existante", uneFenetre, "Une grille existe déjà sous ce nom. Écraser la grille existante ?")
							
							if choix then
							
								unModele.miseAJourGrille(d.etNomGrille.text)
								DialogueInfo.afficher("Sauvegarde de la grille", "Grille sauvegardée avec succès\nL'ancienne grille a été écrasée", uneFenetre)
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
