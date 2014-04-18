require 'sqlite3'

#Les modèles définiront les structures de donnée de notre programme ainsi que les intéractions sur ces structures. Tout modèle sera connecté à la base de donnée et pourra mettre à jour ses observateurs
class Modele

    @observateurs
    @bdd
    @profil
    
    private_class_method :new
    
    def initialize(unProfil)

    	$fichierBDD = "test.sqlite"
    	
    	@observateurs = Array.new
    	
    	@bdd = SQLite3::Database.open $fichierBDD

    	@bdd.results_as_hash = true#Utile pour retourner les résultats dans un tableau de hash
    	
    	@profil = unProfil
    end
    
    #Ajoute un observateur dans la liste des observateurs
    def ajouterObservateur(unObservateur)
    
    	@observateurs.push(unObservateur)
    end
    
    #Retire unObservateur de la liste des observateurs
    def enleverObservateur(unObservateur)
    
    	@observaeurs.delete(unObservateur)
    end
    
    #Met à jour l'ensemble des observateurs
    def lancerMaj
    
    	@observateurs.each{|unObservateur|
    	
    		unObservateur.miseAJour
    	}
    end
    
    #Effectue la requête uneRequete auprès de la base de donnée, en cas d'erreur le programme quitte afin de pouvoir mieux le débugger
    def requete(uneRequete)
    
    	begin
    	
    		resultat = @bdd.execute(uneRequete)
    		return resultat if not resultat.empty?
    		
    	rescue SQLite3::Exception => e 
    	
    		puts "Erreur dans l'interaction avec la base de donnee"
    		puts e	
    		exit -1	
    	end
	end
    
    #Ferme la connection avec la bdd pour le modèle en cours
    def fermerBdd
    
    	@bdd.close
    end
    
    #Cette méthode charge un profil à partir d'un pseudo en allant chercher dans la base de donnée
    def chargerProfil(unPseudo)
    
    	
    end
end
