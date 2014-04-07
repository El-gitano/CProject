require './Grille.rb'

print "\n\nDECLARATION GRILLE\n\n"

g = Grille.new(5)
print g.to_debug

print "\n\nMODIFICATION GRILLE\n\n"

g.getCase(0, 1).clicGauche

g.operationLigne(3){|y|

	y.clicDroit
}

g.operationColonne(2){|x|

	x.clicDroit
}

print g.to_debug

print "\n\nACCESS GRILLE\n\n"

print g.getCase(3, 2).to_debug
print g.getCase(0, 1).to_debug
