# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleJeu'
require 'date'

class ModeleJeu < ModeleGrille
    @plateauJeu
    attr_reader :plateauJeu
end