class ControleurEditeur < Controleur

	# Constructeur
	def initialize(unJeu, unModele)

		super(unJeu, unModele)

		@picross.controleur = self
		@picross.vue = VueEditeur.changer(self)
		@picross.modele = ModeleEditeur.changer(@picross.vue)	
	end

	# Retour a l'accueil
	def retourAccueil
	end

	# Sauvegarder un plateau
	def sauverPlateau(unPlateau)
	end

	# Editer un plateau
	def editerPlateau(unPlateau)
	end
end
