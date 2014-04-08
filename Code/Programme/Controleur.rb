class Controleur

    @picross
    @modele
    attr_reader :picross, :modele

	# Constructeur et remplacement du new
	private_class_method :new

    def initialize(unJeu, unModele)
	    @picross = unJeu
		@modele = unModele
	end  

	def Controleur.changer(unJeu, unModele)
		new(unJeu, unModele)
	end           
end



