# encoding: UTF-8

require './Vues/Vue'

#Vue chargée d'effectuer le lien entre le contrôleur et l'utilisateur lors de l'écran d'accueil
class VueAccueil < Vue
	
	@boutonJouer
	@boutonEditer
	@boutonCredit
	@boutonProfil
	@boutonDeco

	
	attr_reader :boutonJouer, :boutonEditer, :boutonCredit, :boutonProfil, :boutonDeco
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Accueil")

		#Lignes de code commentées pour les tests
		@window.set_size_request(350,800)
		
		#Cette box contient les 5 lignes champs + bouton
		vbox = Gtk::VBox.new(false, 50)
		vbox.set_border_width(20) #On espace la vBox de la fenêtre
		hbox = Gtk::HBox.new(false, 0)

		arial18 = Pango::FontDescription.new('Arial 25')

		@boutonProfil = Gtk::Button.new(@modele.profil.pseudo, false)
		@boutonProfil.child.modify_font(arial18)
		@boutonDeco = Gtk::Button.new("", false)
		@boutonJouer = Gtk::Button.new("Jouer", false)
		@boutonJouer.child.modify_font(arial18)
		@boutonEditer = Gtk::Button.new("Éditeur", false)
		@boutonEditer.child.modify_font(arial18)
		@boutonCredit = Gtk::Button.new("Crédits", false)
		@boutonCredit.child.modify_font(arial18)

		imgDeco = Gtk::Image.new('./Vues/Images/croix2.png')
		@boutonDeco.set_image(imgDeco)

		imgDeco.show()

		pixAnim = Gdk::PixbufAnimation.new('./Vues/Images/animation.GIF')
		animation = Gtk::Image.new(nil)
		animation.set_pixbuf_animation(pixAnim)
		
		vbox.pack_start(animation, false, false,0)
		vbox.pack_start(@boutonJouer, false, false, 0)
		vbox.pack_start(@boutonEditer, false, false, 0)
		vbox.pack_start(@boutonCredit, false, false, 0)
		vbox.pack_start(hbox, true, false, 0)
		hbox.pack_start(@boutonProfil, true, true, 0)
		hbox.pack_start(@boutonDeco, true, false, 0)
		
		@window.add(vbox)		
		@window.signal_connect('destroy') { Gtk.main_quit }
		@window.show_all
		
	end
	
	
end
