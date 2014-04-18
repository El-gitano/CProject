# encoding: utf-8
class ControleurEditeur < Controleur

	public_class_method :new
	
	# Constructeur
	def initialize(unJeu, unProfil)

		super(unJeu)

		@modele = ModeleEditeur.new(unProfil)
		@vue = VueDemarrage.new(@modele)
		
		@modele.ajouterObservateur(@vue)
	end

	@vue.boutonOuvrir.signal_connect("clicked"){
	
	}
	
	@vue.boutonEnregistrer.signal_connect("clicked"){
	
	}
	
	@vue.boutonAleatoire.signal_connect("clicked"){
	
	}
	
	@vue.bouton5.signal_connect("clicked"){
		@modele.grille = GrilleEditeur.creerGrille(5)
		@modele.lancerMaj
	}
	
	@vue.bouton10.signal_connect("clicked"){
		@modele.grille = GrilleEditeur.creerGrille(10)
		@modele.lancerMaj	
	}
	
	@vue.bouton15.signal_connect("clicked"){
		@modele.grille = GrilleEditeur.creerGrille(15)
		@modele.lancerMaj	
	}
	
	@vue.bouton20.signal_connect("clicked"){
		@modele.grille = GrilleEditeur.creerGrille(20)
		@modele.lancerMaj	
	}
	
	@vue.bouton25.signal_connect("clicked"){
		@modele.grille = GrilleEditeur.creerGrille(25)
		@modele.lancerMaj	
	}
	
	# Retour a l'accueil
	def retourAccueil
		changerControleur(ControleurAccueil.new(@picross, @modele.profil))
	end
end
