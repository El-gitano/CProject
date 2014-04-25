require './Modeles/ModeleEditeur.rb'
modeleedit=ModeleEditeur.new('Pierre',15)


print modeleedit.sauvegarder('magrille')
modeleedit.charger('magrille')

print modeleedit

