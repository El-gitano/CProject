require 'sqlite3'

class Modele

    @observateurs
    @bdd
    
    def initialize
    	
    	$fichierBDD = "test.sqlite"
    	@observateurs = Array.new
    	@bdd = SQLite3::Database.open $fichierBDD
    	@bdd.results_as_hash = true#Utile pour retourner les résultats dans un tableau de hash
    	
    end
    
    def ajouterObservateur(unObservateur)
    
    	@observateurs.push(unObservateur)
    end
    
    def enleverObservateur(unObservateur)
    
    	@observaeurs.delete(unObservateur)
    end
    
    def lancerMaj
    
    	@observateurs.each{|unObservateur|
    	
    		unObservateur.miseAJour
    	}
    end
    
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
    
    def fermerBdd()
    
    	@bdd.close
    end
end
