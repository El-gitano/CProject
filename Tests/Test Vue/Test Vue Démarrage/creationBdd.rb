require 'sqlite3'

begin

	bdd = SQLite3::Database.new "test.sqlite"
	
	bdd.execute "CREATE TABLE profil(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, pseudo VARCHAR NOT NULL, pass VARCHAR)"
	
rescue SQLite3::Exception => e 

	puts "Erreur dans la creation du fichier"
	puts e
	
ensure

	bdd.close

end
