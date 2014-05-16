#encoding: UTF-8

#La classe InfoGrille parcourt une grille afin de déterminer le nombre de blocs successifs pour chaque ligne et chaque colonne qu'elle stocke dans ses variables internes
class InfosGrille

	@infosLignes
	@infosColonnes
	
	attr_reader :infosLignes, :infosColonnes
	
	def initialize
	
		@infosLignes = Array.new
		@infosColonnes = Array.new
	end
	
	#Génère les informations pour les lignes et colonnes d'une instance Grille
	def genererInfos(uneGrille)
	
		@infosLignes.clear
		@infosColonnes.clear
		
		#Remplissage infos lignes
		0.upto(uneGrille.taille - 1){|x|
		
			@infosLignes.push(Array.new)
			cpt = 0#Variable "compteur" de cases pleines
			zero = true
			cases = false
			
			uneGrille.operationLigne(x){|uneCase|
		
				if uneCase.jouee? then
				
					cases = true
					cpt += 1
					zero = false
				
				elsif cases == true then
				
					cases = false
					
					@infosLignes[x].push(cpt)
					
					cpt = 0
				end
			}
			
			if cases == true then
			
				@infosLignes[x].push(cpt)
			
			elsif zero == true
				@infosLignes[x].push(0)
			end
			
		}
		
		#Remplissage infos colonnes
		0.upto(uneGrille.taille - 1){|x|
		
			@infosColonnes.push(Array.new)
			cpt = 0#Variable "compteur" de cases pleines
			cases = false
			zero = true

			uneGrille.operationColonne(x){|uneCase|
		
				if uneCase.jouee? then
				
					cases = true
					cpt += 1
					zero = false
				
				elsif cases == true then
				
					cases = false
					
					@infosColonnes[x].push(cpt)
					
					cpt = 0
				end
			}
			
			#Pour la fin
			if cases == true then
			
				@infosColonnes[x].push(cpt)
			elsif zero == true
				@infosColonnes[x].push(0)
			end

			@infosColonnes[x] = @infosColonnes[x].reverse
		}
	end
	
	def getInfoLigne(y)
	
		return @infosLignes[y]
	end
	
	def getInfoColonne(x)
	
		return @infosColonnes[x]
	end
	def to_debug
	
		i = 0
		
		@infosLignes.each{|x|
		
			i += 1
			
			print "\n\nLigne numero : #{i}\n\n"
			
			x.each{|num|
			
				print " #{num} "
			}
		}
		
		i = 0
		
		@infosColonnes.each{|x|
		
			i += 1
			
			print "\n\nColonne numero : #{i}\n\n"
			
			x.each{|num|
			
				print " #{num} "
			}
		}
		
	end
end
