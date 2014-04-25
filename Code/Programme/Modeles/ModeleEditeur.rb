require './Modeles/Modele'
require './Modeles/Grilles/GrilleEditeur'

#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < Modele
	
	@grille
	@nbJokers
   	@nomGrille
   	 
	attr_writer :grille

	public_class_method :new
	
	def initialize(unProfil, taille)
	
		super(unProfil)
        @nbJokers=0
        @taille=taille
		@grille = GrilleEditeur.Creer(taille)
		
	end

    def setNbJokers(nbjoker)
    
        @nbJokers=nbjoker
    end

    def grilleExiste?(nom)
    
        grille = self.requete("SELECT * FROM grilleediter WHERE nomgrille = '#{nom}'")
        return grille[0]["nomgrille"]!=nil
    end

    def sauvegarder(nom)
    
        @nomGrille=nom
        serial=@grille.serialize
        tailleGrille=@grille.taille
        
        if grilleExiste?(nom)
            return false
        else
            self.requete("INSERT INTO grilleediter(createur,nomgrille,taillegrille,grille,nbjokers) VALUES('#{@profil}','#{@nomGrille}','#{@tailleGrille}','#{serial}','#{@nbJokers}')")
            return true
        end
    end

    def charger(nom)
        grilletmp=self.requete("SELECT * FROM grilleediter WHERE nomgrille='#{nom}'")
        @grille=Grille.deserialize(grilletmp[0]["grille"])
        @nbJokers=grilletmp[0]["nbjokers"]
        @nomGrille=grilletmp[0]["nomgrille"]
        @taille=grilletmp[0]["taillegrille"]
    end

    def to_s
        print "\n",@nomGrille," ",@nbJokers," ",@taille,"\n"
        @grille.to_debug
    end
end
