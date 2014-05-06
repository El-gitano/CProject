# encoding: utf-8

require './Modeles/Modele'
require './Modeles/Grilles/GrilleEditeur'
require 'date'


#Le modèle de l'éditeur permet de manipuler la grille à éditer ainsi que d'en sauvegarder/charger une
class ModeleEditeur < Modele
	
	@grille
	#@nbJokers
    #@nomGrille
	
	attr_reader :grille
	attr_writer :grille

	public_class_method :new
	
	def initialize(unProfil, taille)
	
		super(unProfil)
        #@nbJokers=0
        #@taille=taille
		@grille = GrilleEditeur.Creer(taille,"NouvelleGrille",unProfil,0)
		#@grille.genererAleatoire
		#@grille.to_debug
		#lancerMaj
	end

    def setNbJokers(nbjoker)
    
        @nbJokers=nbjoker
    end

    def grilleExiste?(nom)
        grille = requete "SELECT COUNT(*) AS 'liste' FROM grilleediter WHERE nomgrille = '#{nom}'"
		return true if grille[0]["liste"] == 1
    end

    def sauvegarder(nom)
        nomGrille=nom
        serial = @grille.casesSerialize
        tailleGrille =@grille.taille
		date = Date.today
        if grilleExiste?(nom)
			print "La grille existe déjà"
            return false
        else
			print "La grille a été crée"
            self.requete("INSERT INTO grilleediter(createur,nomgrille,taillegrille,grille,nbjokers,datecreation,datemaj) VALUES('#{@profil}','#{nomGrille}','#{tailleGrille}','#{serial}','#{@nbJokers}',#{date},#{date})")
            return true
        end
    end

    def charger(nom)
        grilletmp=self.requete("SELECT * FROM grilleediter WHERE nomgrille='#{nom}'")
        @grille.cases = Grille.casesDeserialize(grilletmp[0]["grille"])
		
		#print grilletmp[0]["grille"]
        @grille.nbJokers=grilletmp[0]["nbjokers"]
        @grille.nomGrille=grilletmp[0]["nomgrille"]
        @grille.taille=grilletmp[0]["taillegrille"]
    end
	
	def listeGrillesEditables(unPseudo)
        grilletmp=self.requete("SELECT * FROM grilleediter WHERE createur='#{unPseudo}'")
		
		
		grilletmp.each do |x|
			modeletmp=ModeleEditeur.new(x["createur"],x["taillegrille"])
			modeletmp.charger(x["nomgrille"])
			yield modeletmp.grille
		end
    end
	
	def getGrille(nomGrille)
        grilletmp=self.requete("SELECT * FROM grilleediter WHERE nomgrille='#{nomGrille}'")
		modeletmp=ModeleEditeur.new(grilletmp[0]["createur"],grilletmp[0]["taillegrille"])
		modeletmp.charger(grilletmp[0]["nomgrille"])
		return modeletmp.grille
    end
	
	def getCase(x,y)
		return grille.getCase(x,y)
    end

    def to_s
        print "\n",@grille.nomGrille," ",@grille.nbJokers," ",@grille.taille,"\n"
        @grille.to_debug
    end
	
end
