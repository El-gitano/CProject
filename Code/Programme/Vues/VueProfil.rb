# encoding: UTF-8

require './Vues/Vue'

class VueProfil < Vue

	@vbox
	@vboxStats
	
	@boutonRenommer
	@boutonEffacer
	@lbPseudo
	
	attr_reader :boutonRenommer, :boutonEffacer
	
	public_class_method :new
	
	def initialize(unModele)
	
		super(unModele, "Profil")

		@window.signal_connect('destroy') { Gtk.main_quit }
		
		@boutonRenommer = Gtk::Button.new("Renommer profil")
		@boutonEffacer = Gtk::Button.new("Réinitialiser les statistiques")
		
		vBox = Gtk::VBox.new(false, 20)
		
		@lbPseudo = Gtk::Label.new
		
		hBoxTitre = Gtk::HBox.new(true, 5)
		imEtoile = Gtk::Image.new("./Vues/Images/etoileCredit.png")
		imEtoile2 = Gtk::Image.new("./Vues/Images/etoileCredit.png")		
		hBoxTitre.pack_start(imEtoile, false, false, 0)
		hBoxTitre.pack_start(@lbPseudo)
		hBoxTitre.pack_start(imEtoile2, false, false, 0)
		
		@vboxStats = Gtk::VBox.new(false, 5)
		
		hBox = Gtk::HBox.new(true, 5)
		hBox.pack_start(@boutonRenommer)
		hBox.pack_start(@boutonEffacer)
		
		vBox.pack_start(hBoxTitre)
		vBox.pack_start(@vboxStats)
		vBox.pack_start(hBox)
		
		vBox.set_border_width(20)
		@window.add(vBox)
		
		miseAJour
		@window.show_all
	end
	
	def miseAJour
	
		@lbPseudo.set_markup("<b>Statistiques de #{@modele.profil.pseudo}</b>")
		
		#On supprime le contenu de la VBox
		@vboxStats.each{|enfant|
		
			enfant.destroy
		}
		
		#Puis on la remplit avec les nouvelles valeurs
		
		#Taux réussite
		phrase = "Taux de réussite :\t"
		
		if not @modele.stats["parties_terminees"].eql?(0) then
		
			valeur = ((@modele.stats["parties_commencees"].to_f / @modele.stats["parties_terminees"].to_f)*100).to_s 	
		else
			
			valeur = 0.to_s
		end
		
		@vboxStats.pack_start(genererLigne(phrase, valeur + "%"))
		
		#Temps joué
		@vboxStats.pack_start(genererLigne("Temps joué :", @modele.stats["temps_joue"].to_s))
			
		#Joker
		@vboxStats.pack_start(genererLigne("Jokers utilisés :", @modele.stats["joker_utilises"].to_s))
		
		#Indices
		@vboxStats.pack_start(genererLigne("Temps joué :", @modele.stats["indices_utilises"].to_s))
		
		#Nombre de grilles crée
		@vboxStats.pack_start(genererLigne("Nombre de grilles crées :", @modele.stats["grilles_crees"].to_s))
		
		#Ragequits
		@vboxStats.pack_start(genererLigne("Nombre de ragequits :", @modele.stats["temps_joue"].to_s))
		
		@vboxStats.show_all
	end
	
	def genererLigne(unePhrase, uneValeur)
	
		hBox = Gtk::HBox.new(true, 5)
		hBox.pack_start(Gtk::Label.new(unePhrase))
		hBox.pack_start(Gtk::Label.new(uneValeur))
		return hBox
	end
end
