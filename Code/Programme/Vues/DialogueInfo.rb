require 'gtk2'

class DialogueInfo < Gtk::Dialog

	private_class_method :new
	
	def DialogueInfo.afficher(unTitre, uneInfo, uneFenetre)
	
		d = new(unTitre, uneInfo, uneFenetre)
		d.show_all
		d.run
		d.destroy
	end
	
	def initialize(unTitre, uneInfo, uneFenetre)
	
		super(unTitre, uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT, [Gtk::Stock::OK, Gtk::Dialog::RESPONSE_ACCEPT])
		set_modal(true)
		
		hbox = Gtk::HBox.new(false, 5)

		image = Gtk::Image.new(Gtk::Stock::DIALOG_INFO, Gtk::IconSize::DIALOG)
		label = Gtk::Label.new(uneInfo)
		
		hbox.pack_start(image, false, false, 0)
		hbox.pack_start(label, false, false, 0)

		vbox.add(hbox)
	end
end
