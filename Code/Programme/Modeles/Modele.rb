require 'sqlite3'
require_relative 'Profil'

#Les modèles définiront les structures de donnée de notre programme ainsi que les intéractions sur ces structures. Tout modèle sera connecté à la base de donnée et pourra mettre à jour ses observateurs
class Modele

    @observateurs
    @bdd
    @profil
    
    attr_reader :profil
    
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
    
    #Met à jour l'ensemble des observateursattr_reader :pseudo
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
    		return Array.new#On retourne un tableau nul si pas de résultat (pour les each)
    		
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
    
    #Sauvegarde le profil en mémoire dans la bdd
    def sauvegarderProfil
		
		#Sauvegarde des stats
		0.upto(@profil.getStats.length/2) do |x|
	
			@profil.getStats.delete(x)
		end	

		id = @profil.getStats["id"]
		req = ""
		
		@profil.getStats.each do |key, value| 
			puts key, value
			req += "'#{key}' = '#{value}', "
		end	
		
		req = req[0...-2]
		
		self.requete("UPDATE stats SET #{req} WHERE id = #{id}") 
	end
end
