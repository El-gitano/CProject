#encoding: UTF-8

require_relative 'ModeleGrille'
require_relative 'ModeleEditeur'

#ModeleOuvrirGrille se charge d'afficher les grilles éditables par un joueur
class ModeleOuvrirGrilleImport < ModeleGrille

	public_class_method :new
	
	def initialize(unProfil)
	
		super(unProfil)
	end
	
	def infosGrillesImportables
		array = Dir.entries("./Import")
		array.delete_at(0)
		array.delete_at(0)
		tmpData = Array.new
		
		#print "profil courant : ",@profil.pseudo,"\n"

		array.each do |x|
			print " nom fich :",x,"\n"
			tmp = ModeleEditeur.new(@profil,10)
			tmp.grille.importerGrille("./Import/"+x)
			#print tmp.grille.to_debug
			tmpData.push(tmp)			
		end

		#print "Affichage données \n",tmpData,"\nfin\n"

		#tmpData.each do |x|
		#	x.grille.to_debug
		#end

		lancerMaj
		return tmpData
	end

end
