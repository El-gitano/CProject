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
