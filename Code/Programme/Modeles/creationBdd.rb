require 'sqlite3'

begin

	bdd = SQLite3::Database.new "test.sqlite"
	
	bdd.execute "CREATE TABLE IF NOT EXISTS profil(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, pseudo VARCHAR NOT NULL, pass VARCHAR)"
    bdd.execute "CREATE TABLE IF NOT EXISTS stats(id INTEGER PRIMARY KEY REFERENCES profil(id) NOT NULL, parties_commencees INTEGER NOT NULL, parties_terminees INTEGER NOT NULL, temps_joue INTEGER NOT NULL, joker_utilises INTEGER NOT NULL, indices_utilises INTEGER NOT NULL, grilles_crees INTEGER NOT NULL, ragequits INTEGER NOT NULL)"
    bdd.execute "CREATE TABLE IF NOT EXISTS grilleediter(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, createur INTEGER NOT NULL REFERENCES profil(id), nomgrille VARCHAR NOT NULL, taillegrille INTEGER NOT NULL, grille VARCHAR NOT NULL, nbjokers INTEGER NT NULL)"

rescue SQLite3::Exception => e 

	puts "Erreur dans la creation du fichier"
	puts e
	
ensure

	bdd.close

end
