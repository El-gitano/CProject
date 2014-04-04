load 'VueInterface.rb'
class Vue
    include VueInterface
    attr_reader :controleur, :builder

    def miseAJour()
    end
    def initialize(controleur)
        @controleur=controleur
    end
    def texte
    super
    print"coco"
    end
end

vue=Vue.new(1)
vue.texte
