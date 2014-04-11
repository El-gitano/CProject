require './ModeleDemarrage'

modele= ModeleDemarrage.new
puts "#{modele.supprimerProfil("pierre")}"
puts "#{modele.supprimerProfil("paul")}"
puts "#{modele.creerProfil("pierre")}"
puts "#{modele.creerProfil("paul")}"

