module VueInterface
    @controleur
    @builder
    attr_reader :controleur, :builder

    def miseAJour()
    end
    def new()
        print"Vous essayez d'instancier une classe abstraite."
    end
    def initialize()
    end
    def texte
    print "coucou"
    end
end