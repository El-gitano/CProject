class ControleurDemarrage < Controleur

	# Constructeur
	def initialize(unJeu, unModele)

		super(unJeu, unModele)

		@picross.controleur = self
		@picross.vue = VueDemarrage.changer(self)
		@picross.modele = ModeleDemarrage.changer(@picross.vue)	
	end

	# Creation de profil
	def creerProfil(unNom)
	
		if (ModeleDemarrage.chercherNom(unNom))
			Profil.creer(unNom)
		else
			print "Erreur : ce pseudo existe deja"
	end

	# Suppression de profil
	def supprimerProfil(unNom)
		Profil.supprimer(unNom)
	end

	# /!\ Choix du profil et changement de triplé
	def choisirProfil(unNom)

		if (ModeleDemarrage.connexion(unNom))
			ControleurAccueil.changer(unJeu, unModeleAccueil)
		else
			print "Erreur : impossible de trouver le profil"		
	end	
end
