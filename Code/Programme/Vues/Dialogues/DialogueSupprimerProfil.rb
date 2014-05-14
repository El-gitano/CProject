#encoding: UTF-8

require 'gtk2'

#Boîte de dialogue chargée de demander au joueur la confirmation de supression d'un profil
class DialogueSupprimerProfil < Gtk::Dialog

	def DialogueSupprimerProfil.afficher(uneFenetre, unProfil)
	
		d = new(uneFenetre, unProfil)
		bool = false
		
		d.run{|reponse|
		
			if reponse == Gtk::Dialog::RESPONSE_ACCEPT then

				bool = true
			end
		}
		
		d.destroy
		
		return bool
	end
	
	def initialize(uneFenetre, unPseudo)
	
		super("Supression du profil #{unPseudo}", uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
			
		hbox = Gtk::HBox.new(false, 5)
	
		label = Gtk::Label.new("Etes vous sûr de vouloir supprimer le profil #{unPseudo} ?")
		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
	
		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)
	
		vbox.add(hbox)
	
		show_all
	end
end
