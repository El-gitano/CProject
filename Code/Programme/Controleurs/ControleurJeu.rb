class ControleurJeu < Controleur

	# Constructeur
	def initialize(unJeu, unModele)

		super(unJeu, unModele)

		@picross.controleur = self
		@picross.vue = VueJeu.changer(self)
		@picross.modele = ModeleJeu.changer(@picross.vue)	
	end

	# Retour a l'accueil
	def retourAccueil
	end

	# Lancer une partie rapide
	def partieRapide
	end

	# Lancer une grille choisie
	def partieClassique(uneGrille)
	end

	# Charger une grille
	def partieContinuer(uneGrille)
	end
end
