#encoding: UTF-8

require 'sqlite3'
require_relative 'Modele'

class ModeleAvecProfil < Modele
    
    @profil
    
    def initialize(unProfil)

		super()
        @profil = unProfil
    end
	
	#Retourne le pseudo du profil
	def getPseudo
	
		return @profil.pseudo
	end
	
	def changerPseudo(unPseudo)
	
		@profil.pseudo = pseudo
	end
	
	#Met à jour le profil actuel ainsi que ses statistiques dans la base de donnée
    def sauvegarderProfil
		
		#Sauvegarde des stats
		0.upto(@profil.getStats.length/2) do |x|
	
			@profil.getStats.delete(x)
		end	

		id = @profil.getStats["id"]
		req = ""
		
		@profil.getStats.each do |key, value| 
	
			req += "'#{key}' = '#{value}', "
		end	
		
		req = req[0...-2]
		
		self.requete("UPDATE stats SET #{req} WHERE id = #{id}") 
	end
end
