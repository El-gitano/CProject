require './ModeleDemarrage'

modele = ModeleDemarrage.new

puts "Test de connexion au profil 'hello'"
puts "#{modele.existe?("hello")}"

puts "Creation profil 'hello'"
puts "#{modele.creerProfil("hello")}"

puts "Creation profil 'world'"
puts "#{modele.creerProfil("world")}"

puts "Test de connexion au profil 'hello'"
puts "#{modele.existe?("hello")}"

print modele.listeProfils

modele.fermerBdd
