require 'gtk2'

#DialogueConfirmation est une boîte de dialogue personnalisable prenant un modèle et retournant la réponse de l'utilisateur lors de son exécution
class DialogueConfirmation < Gtk::Dialog

	private_class_method :new
	
	#Cette méthode crée le dialogue et le lance
	def DialogueConfirmation.afficher(unTitre, uneFenetre, uneQuestion)
	
		d = new(unTitre, uneFenetre, uneQuestion)
		d.show_all
		retour = nil
		
		d.run{|reponse|
		
			case reponse
				
				#L'utilisateur confirme l'action
				when Gtk::Dialog::RESPONSE_ACCEPT
				
					retour = true
					
				#L'utilisateur annule l'action
				when Gtk::Dialog::RESPONSE_REJECT
				
					retour = false
			end
		}
		
		d.destroy
		return retour
	end
	
	def initialize(unTitre, uneFenetre, uneQuestion)
	
		super(unTitre, uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_REJECT], [Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_ACCEPT])
		
		set_modal(true)

		hbox = Gtk::HBox.new(false, 5)

		label = Gtk::Label.new(uneQuestion)
		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)

		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)

		vbox.add(hbox)
	end
end
