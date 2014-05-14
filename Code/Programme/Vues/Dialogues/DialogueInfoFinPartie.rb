#encoding: UTF-8
require_relative '../../Modeles/ModeleJeu'

require 'gtk2'

#DialogueInfo est une boîte de dialogue informative prenant en paramètre le titre et le texte de la boîte lors de son instanciation

class DialogueInfoFinPartie < Gtk::Dialog

	@modele

	private_class_method :new
	
	#Cette méthode crée le dialogue et le lance
	def DialogueInfoFinPartie.afficher(unTitre, unModele, uneFenetre)
	
		d = new(unTitre, unModele, uneFenetre)
		d.show_all
		d.run
		d.destroy
	end

	def initialize(unTitre, unModele, uneFenetre)
	
		super(unTitre, uneFenetre, Gtk::Dialog::DESTROY_WITH_PARENT,["Nouvelle Partie", Gtk::Dialog::RESPONSE_ACCEPT],["Retour à l'accueil", Gtk::Dialog::RESPONSE_REJECT])

		@modele = unModele

		# Creation des box
		hbox1 = Gtk::HBox.new(false, 5)	

		hbox2 = Gtk::HBox.new(false, 5)	
		vbox1 = Gtk::VBox.new(false, 5)
		vbox2 = Gtk::VBox.new(false, 5)

		# Creation des elements
		labelInfo = Gtk::Label.new("La grille est valide ! \n")	
		labelClic = Gtk::Label.new("Nombre de clics : ")
		labelJoker = Gtk::Label.new("Nombre de jokers utilises : ")
		labelTemps = Gtk::Label.new("Temps ecoule : ")

		nbJokerUtilise = @modele.plateauJeu.nbJokers - @modele.plateauJeu.nbJokers
		labelNbClic = Gtk::Label.new(@modele.profil.getStats["nombre_clics"].to_s)
		labelNbJoker = Gtk::Label.new(nbJokerUtilise.to_s)
		labelTempsEcoule = Gtk::Label.new(@modele.timer.tempsEcoule.to_s)

		# Ajout des elements
		vbox.add(hbox1)

		vbox.add(hbox2)
		hbox2.add(vbox1)
		hbox2.add(vbox2)
		
		hbox1.add(labelInfo)

		vbox1.add(labelClic)
		vbox1.add(labelJoker)
		vbox1.add(labelTemps)

		vbox2.add(labelNbClic)	
		vbox2.add(labelNbJoker)
		vbox2.add(labelTempsEcoule)

		# Affichage des elements et lancement de la fenetre
		show_all
		
	end	
end
