require 'sqlite3'
require './Modeles/Modele'

class ModeleAvecProfil < Modele
    
    @profil

    def initialize(pseudo)

        stats = self.requete("SELECT * FROM profil INNER JOIN stats ON profil.id = stats.id WHERE  #{pseudo} = profil.pseudo")
        @profil = profil.ouvrir(pseudo, stats)
    end

	#Met à jour le profil actuel dans la base de donnée
	def sauvegarderProfil
		
		
	end
	
	def getPseudo
	
		return @profil.pseudo
	end
end
