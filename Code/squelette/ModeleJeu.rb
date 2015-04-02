# encoding: utf-8

require './Modeles/ModeleGrille'
require './Modeles/Grilles/GrilleJeu'
require 'date'

class ModeleJeu < ModeleGrille

	public_class_method :new
	
	@plateauJeu

	def initialize(unProfil, uneTaille)
	
		super(unProfil,uneTaille)
		@plateauJeu = GrilleEditeur.Creer(uneTaille, "NouvelleGrille", unProfil, 0)
	end
	

	
	
	
	
    attr_reader :plateauJeu
end