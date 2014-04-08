class ControleurAccueil < Controleur

	# Constructeur
	def initialize(unJeu, unModele)

		super(unJeu, unModele)

		@picross.controleur = self
		@picross.vue = VueAccueil.changer(self)
		@picross.modele = ModeleAccueil.changer(@picross.vue)	
	end

	# Acceder a l'editeur
	def lancerEditeur
	end

	# Acceder au jeu
	def lancerJeu
	end

	# Regarder les options
	def regarderOptions
	end

	# Acceder au profil
	def profilAcceder
	end

	# Voir les credits
	def creditVoir
	end
end
