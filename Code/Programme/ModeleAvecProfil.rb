require 'sqlite3'
require './Modele'

class ModeleAvecProfil < Modele
    @profil

    def initialize(pseudo)
        self
        stats = self.requete("SELECT * FROM profil INNER JOIN stats ON profil.id = stats.id WHERE  #{pseudo} = profil.pseudo")
        @profil = profil.ouvrir(pseudo,stats)
    end

end