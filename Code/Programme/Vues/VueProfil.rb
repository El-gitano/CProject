# encoding: UTF-8

require_relative 'Vue'
require_relative 'Listeurs/ListeurStats'

class VueProfil < Vue

	@vbox
	@listeur
	
	@boutonRenommer
	@boutonEffacer
	@boutonRetour
	@lbPseudo
	
	attr_reader :boutonRenommer, :boutonEffacer, :boutonRetour
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Profil/Classement")

		@window.signal_connect('destroy') {Gtk.main_quit}
		
		@boutonRenommer = Gtk::Button.new("Renommer mon profil")
		@boutonEffacer = Gtk::Button.new("Réinitialiser mes statistiques")
		@boutonRetour = Gtk::Button.new("Retour à l'accueil")
		
		vBox = Gtk::VBox.new(false, 20)
		
		@lbPseudo = Gtk::Label.new
		
		hBoxTitre = Gtk::HBox.new(true, 5)
		imEtoile = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		imEtoile2 = Gtk::Image.new("./Vues/Images/etoileCredit.png")		
		hBoxTitre.pack_start(imEtoile, false, false, 0)
		hBoxTitre.pack_start(@lbPseudo)
		hBoxTitre.pack_start(imEtoile2, false, false, 0)
		
		@listeur = ListeurStats.new(@modele)
		
		hBox = Gtk::HBox.new(true, 5)
		hBox.pack_start(@boutonRetour, true, true, 0)
		hBox.pack_start(@boutonRenommer, true, true, 0)
		hBox.pack_start(@boutonEffacer, true, true, 0)
		
		vBox.pack_start(hBoxTitre, false, false, 0)
		vBox.pack_start(@listeur, false, false, 0)
		vBox.pack_start(hBox, false, false, 0)
		
		vBox.set_border_width(20)
		@window.add(vBox)
		
		miseAJour
		@window.show_all
	end
	
	def miseAJour
	
		@lbPseudo.set_markup("<b>Statistiques et classement de #{@modele.profil.pseudo}</b>")
		@listeur.maj
		
	end
	
	def genererLigne(unePhrase, uneValeur)
	
		hBox = Gtk::HBox.new(true, 5)
		hBox.pack_start(Gtk::Label.new(unePhrase))
		hBox.pack_start(Gtk::Label.new(uneValeur))
		return hBox
	end
end
