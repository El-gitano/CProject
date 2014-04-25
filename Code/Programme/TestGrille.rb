require './Modeles/ModeleEditeur.rb'
modeleedit=ModeleEditeur.new('Pierre',15)


modeleedit.sauvegarder('magrille')
modeleedit.charger('magrille')

print modeleedit

print "\n"


