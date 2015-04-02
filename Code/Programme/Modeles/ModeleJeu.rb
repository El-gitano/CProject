# encoding: utf-8

require_relative 'ModeleGrille'
require_relative 'Grilles/GrilleJeu'
require_relative 'Grilles/GrilleEditeur'
require_relative 'Grilles/InfosGrille'
require_relative 'Grilles/EtatsCases/EtatCaseCroix'
require_relative 'Grilles/EtatsCases/EtatCaseJouee'
require_relative 'Timer'

require 'date'
require 'set'

class ModeleJeu < ModeleGrille

	public_class_method :new
	
	@plateauJeu#Grille de jeu
	@grille#Grille de référence (solution)
	@timer
	
	@informations#Informations numériques sur la grille de référence
	
	attr_reader :plateauJeu, :timer, :informations

	#Un choix à true désigne une sauvegarde à charger, à false une nouvelle partie, le nom correspond à la sauvegarde ou au nom de la grille
	def initialize(unProfil, unChoix, unNom)
	
		super(unProfil)
		
		if unChoix == true then
		
			chargerPartie(unNom)
		else
		
			nouvellePartie(unNom, unNom)
		end
	end
	
	#Retourne un indice de jeu au joueur
	def getIndice
	
		ajouterIndice
		solutions = chercherSolutions
		
		return nil if solutions.empty?
		return solutions	
		
	end
	
	#Retourne vrai si la grille du joueur répond aux critères de la grille de solution
	def grilleValide?
	
		#Génération des indices de la grille de jeu
		informationsTemp = InfosGrille.new
		informationsTemp.genererInfos(@plateauJeu)
		
		#Comparaison des deux informations de grille
		valide =  (informationsTemp.infosLignes == @informations.infosLignes and  informationsTemp.infosColonnes == @informations.infosColonnes)
		
		if valide then #Si grille terminée, +1 au nombre de partie terminées puis maj modification
		
			@timer.stopperTimer			
			@profil.getStats["parties_terminees"] += 1
			sauvegarderProfil
		end
		
		return valide
	end
	
	#Écrase la sauvegarde "nomPartie" avec des nouvelles données
	def remplacerSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")

		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{sanitize(@grille.nomGrille)}'") 
		req = "UPDATE grillejouee SET grille='#{serial}', jokersRestants='#{nbJokers}', timer='#{@timer.temps}', datemaj='#{date}' WHERE joueur='#{@profil.getStats["id"]}' AND nompartie='#{sanitize(nomPartie)}' AND idGrille='#{idGrilleRef[0]["id"]}'"

		requete(req)
	end
	
	#Retourne vrai si le nom de sauvegarde passé en paramètre existe déjà pour un joueur
	def sauvegardeExiste?(nomSauvegarde)
	
		return !requete("SELECT * FROM grillejouee WHERE nompartie = '#{sanitize(nomSauvegarde)}' AND joueur = #{@profil.getStats["id"]}").empty?
	end
	
	#Crée une nouvelle sauvegarde pour un joueur
	def nouvelleSauvegarde(nomPartie)

		serial = @plateauJeu.casesSerialize
        nbJokers = @plateauJeu.nbJokers
		date = Time.now.strftime("%d/%m/%Y %H:%M")

		idGrilleRef = requete("SELECT id FROM grilleediter WHERE nomgrille = '#{sanitize(@grille.nomGrille)}'")[0]["id"]
		requete("INSERT INTO grillejouee(joueur, idGrille, nompartie, grille, jokersRestants, timer, datedebut, datemaj) VALUES('#{@profil.getStats["id"]}','#{idGrilleRef}','#{sanitize(nomPartie)}','#{serial}','#{nbJokers}','#{@timer.temps}','#{date}','#{date}')")
		
	end
	
	#Démarre une nouvelle partie
	def nouvellePartie(nomPartie, uneGrille)

		@timer = Timer.new(0,@profil)
		
		#On récupère les infos de la grille passées en paramètre puis on instancie une GrilleEditeur
		charger(uneGrille)
		
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)

		@profil.getStats["parties_commencees"] += 1
		
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)

		lancerMaj
		@timer.lancerTimer	
	end
	
	#Charge une partie depuis son nom
	def chargerPartie(nomPartie)

		reqTemp = requete("SELECT * FROM grillejouee WHERE nompartie='#{sanitize(nomPartie)}' AND joueur='#{@profil.getStats["id"]}'")
		nomGrilleRef = requete("SELECT nomgrille FROM grilleediter WHERE id='#{reqTemp[0]["idGrille"]}'")
		
		@grille = charger(nomGrilleRef[0]["nomgrille"])
		@informations = InfosGrille.new
		@informations.genererInfos(@grille)
		
		@plateauJeu = GrilleJeu.Creer(@grille.taille, nomPartie, @profil, @grille.nbJokers)
		@plateauJeu.cases = Grille.casesDeserialize(reqTemp[0]["grille"])  
		@plateauJeu.nbJokers = reqTemp[0]["jokersRestants"]
		
		@timer = Timer.new(reqTemp[0]["timer"], @profil)
		@timer.lancerTimer			
	end
	
	#Remet toutes les cases à l'état croix de la grille à l'état neutre
	def enleverCroix
	
		@plateauJeu.operationGrille{|uneCase|
		
			if uneCase.croix? then
			
				uneCase.changerEtat(EtatCaseNeutre.getInstance)
			end
		}
	end
	
	#Dévoile une case aléatoirement dans le jeu
	def utiliserJoker
	
		#On récupère les cases qui diffèrent de la solution dans le jeu
		casesFausses = Array.new
		
		0.upto((@plateauJeu.taille-1)){|x|
		
			0.upto((@plateauJeu.taille-1)){|y|
			
				casesFausses.push(@plateauJeu.getCase(x, y)) if (@plateauJeu.getCase(x, y).etat != @grille.getCase(x, y).etat)
			}
		}

		indice = Random.rand(casesFausses.size)
		
		caseAChanger = casesFausses[indice]
		
		#On met la solution
		caseSolution = @grille.getCase(caseAChanger.x, caseAChanger.y)
		
		if caseSolution.neutre? then
			
			caseAChanger.changerEtat(EtatCaseCroix.getInstance)
		
		elsif caseSolution.jouee? then
		
			caseAChanger.changerEtat(EtatCaseJouee.getInstance)
		end
				
		enleverJoker
	end
	
	#Enlève un joker pour le joueur
	def enleverJoker
	
		@plateauJeu.nbJokers -= 1
		ajouterJoker
	end
	
	#Retourne une case de la grille de jeu
	def getCase(x,y)
	
		return @plateauJeu.getCase(x,y)
    end
    	
    #Retourne un tableau contenant les coordonnées des cases résolvables par le joueur au moment de l'appel
    def chercherSolutions
    
    	setCases = Set.new
    	
    	0.upto(@plateauJeu.taille-1){|i|
    	
    		setCases.merge(chercherTableau(@plateauJeu.getColonne(i), @informations.getInfoColonne(i), false)) if not tabPleins(@plateauJeu.getColonne(i), @informations.getInfoColonne(i))
    		setCases.merge(chercherTableau(@plateauJeu.getLigne(i), @informations.getInfoLigne(i), true)) if not tabPleins(@plateauJeu.getLigne(i), @informations.getInfoLigne(i))
    	}
    	
    	return setCases
    end
    
    #Retourne true si le nombre de cases du tableau correspond à la somme des indices
    def tabPleins(tab, indices)
    
    	return compareInfoTab(tab, indices).eql?(0)
    end
    
    #Cherche les cases résolvables par le joueur pour une ligne ou une colonne (application des stratégies de résolution)
    #True = ligne
    #False = colonnes
    def chercherTableau(desCases, desInfos, unSens)
    
    	res = Set.new
  	
    	#Toutes les cases doivent être jouées
    	if desInfos.size.eql?(1) and desInfos[0].eql?(@plateauJeu.taille) then
    	
    		res.merge(desCases.select{|laCase| laCase.neutre?})
    	end
  	
    	#Une case sur deux est pleine dans la ligne
    	if desInfos.size.eql?((@plateauJeu.taille/2)+1) then
    	
    		desCases.each_with_index{|laCase, i|
    		
    			res.add(laCase) if ((i%2).eql?(0) and laCase.neutre?)
    		}
    	end
    	
    	#On détermine les cases qui sont à jouer au milieu de la grille
    	if desInfos.size.eql?(1) and desInfos[0] > (@plateauJeu.taille/2) then
    		
    		desCases.each_with_index{|laCase, i|
    		
				res.add(laCase) if laCase.neutre? and (i < desInfos[0]) and i > (@plateauJeu.taille-desInfos[0]-1)
    		} 		
    	end

		sommeInfo = 0
		desInfos.each{|x| sommeInfo += x}
		
		#L'ensemble des cases + espaces remplit la ligne/colonne
		if (desInfos.size-1 + sommeInfo).eql?(@plateauJeu.taille) then
		
			i = 0
			desInfos.each{|info|
			
				i.upto(info-1){|j|
				
					res.add(desCases[j]) if desCases[j].neutre?
				}
				
				i+=1 if info != desInfos.last
			}
		end	
		

    	#Traitement générique sur les informations du tableau
    	desInfos.each{|uneInfo|
    		
    		#Emplacements neutres de la taille de l'info
    		empLibresOk = emplacementsDisponibles(desCases, unSens).select{|unEmplacement| unEmplacement[0].eql?(uneInfo)}
    		
    		#Emplacements joues de la taille de l'info
    		empOccupesOk = emplacementsJoues(desCases).select{|unEmplacement| unEmplacement[1].eql?(uneInfo)}
    		
    		#Si on a une suite de cases neutres qui elles seules peuvent convenir à l'information, on ajoute les cases de cette suite
    		if !empOccupesOk.size.eql?(nombreOccInfos(desInfos, uneInfo)) then
    		
    			empLibresOk.each{|b|
			
					depart = b[1]
					etendue = b[0]
					
					depart.upto(depart+etendue-1){|i|
					
						res.add(desCases[i])
					}
				}
    		end

			
    	}
   	
    	return res
    end
    
    #Retourne le nombre d'occurence de i dans le tableau des informations
    def nombreOccInfos(tabInfos, i)
    
    	res = 0
    	
    	tabInfos.each{|info|
    	
    		res += 1 if info.eql?(i)
    	}
    	
    	return res
    end
    
    #Retourne un tableau contenant, au vu de l'organisation de la ligne/colonne, les positions de départ des cases neutres ainsi que leurs étendue
    def emplacementsDisponibles(tabCases, unSens)
    
    	suiteCase = false
    	res = Array.new
    	etendue = 0
    	depart = 0
    	
    	tabCases.each_with_index{|laCase, i|
    	
    		#On traite les lignes
    		if unSens then
    		
    			if (laCase.neutre?  and !tabPleins(@plateauJeu.getColonne(laCase.x), @informations.getInfoColonne(laCase.x))) or (laCase.jouee? and (compareInfoTab(@plateauJeu.getColonne(laCase.x), @informations.getInfoColonne(laCase.x) )<= 0)) then
    		
    				etendue += 1
					depart = i if suiteCase == false
					suiteCase = true
				
				#On a pas de case ou on a arrêté une suite	
				else
				
					#On arrête une suite de cases
					if suiteCase == true then 

						res.push([etendue, depart]) 
						etendue = 0
					end
					
					suiteCase = false
				end
					
    		#On traite les colonnes
    		else
    		
    			if (laCase.neutre?  and !tabPleins(@plateauJeu.getLigne(laCase.y), @informations.getInfoLigne(laCase.y))) or (laCase.jouee? and (compareInfoTab(@plateauJeu.getLigne(laCase.y), @informations.getInfoLigne(laCase.y) )<= 0)) then
    		
    				etendue += 1
					depart = i if suiteCase == false
					suiteCase = true
				
				#On a pas de case ou on a arrêté une suite	
				else
				
					#On arrête une suite de cases
					if suiteCase == true then 

						res.push([etendue, depart]) 
						etendue = 0
					end
					
					suiteCase = false
				end
    		end
		}
		
		#En cas de sortie avant la fin du bloc
		res.push([etendue, depart])  if suiteCase 
		
    	return res
    end
    
    #Retourne l'indice de départ et l'étendue des blocs de cases jouées pour une ligne/colonne donnée
    def emplacementsJoues(tabCases)
    
    	suiteCase = false
    	res = Array.new
    
    	etendue = 0
    	depart = 0
    	
    	tabCases.each_with_index{|laCase, i|
    	
    		#On commence ou on continue une suite de cases jouees
    		if laCase.jouee? then
    		
    			etendue += 1
    			depart = i if suiteCase == false
    			suiteCase = true
    		
    		#On a pas de case ou on a arrêté une suite	
    		else
    		
    			#On arrête une suite de cases
    			if suiteCase == true then 
    			
    				res.push([etendue, depart]) 
    				etendue = 0
    			end
    			
    			suiteCase = false
    		end
    	}
    	
    	return res
    end
    
    #Retourne un tableau des lignes et colonnes contenant plus de cases jouees que spécifié dans leurs infos ou nil si tout va bien
    def chercherErreursTrop
    
    	erreursLigne = Array.new
    	erreursColonne = Array.new
    	
    	0.upto(@plateauJeu.taille-1){|i|
    	
    		erreursLigne.push(i) if compareInfoTab(@plateauJeu.getLigne(i), @informations.getInfoLigne(i)) > 0
    		erreursColonne.push(i) if compareInfoTab(@plateauJeu.getColonne(i), @informations.getInfoColonne(i)) > 0
    	}
    	
    	return nil if (erreursLigne.empty? and erreursColonne.empty?)
    	return [erreursLigne, erreursColonne]
    	
    end
    
    #Retourne un tableau désignant les lignes et colonnes où les blocs ne correspondent pas aux infos
    def chercherErreursBlocs
    
    	erreursLigne = Array.new
    	erreursColonne = Array.new
    	
    	0.upto(@plateauJeu.taille-1){|i|
    	
    		erreursLigne.push(i) if !checkBlocs(emplacementsJoues(@plateauJeu.getLigne(i)), @informations.getInfoLigne(i))
    		erreursColonne.push(i) if !checkBlocs(emplacementsJoues(@plateauJeu.getColonne(i)), @informations.getInfoColonne(i))
    	}
    	
    	return nil if (erreursLigne.empty? and erreursColonne.empty?)
    	return [erreursLigne, erreursColonne]
    end
    
    #Retourne vrai s'il n'y a pas de bloc supérieur aux infos lignes/colonnes dans celle-ci
    def checkBlocs(tabBlocs, infos)
    
    	maxEtendue = 0
    	maxInfos = 0
    	
    	infos.each{|x|
    	
    		maxInfos = x if x > maxInfos
    	}
    	
    	tabBlocs.each{|bloc|
    	
    		maxEtendue = bloc[0] if bloc[0] > maxEtendue
    	}
    	
    	return maxEtendue <= maxInfos
    end
    
    #Retourne >0 si le nb de cases jouées est supérieur aux infos, <0 pour l'inverse et 0 en cas d'égalite
    def compareInfoTab(unTab, desInfos)
    
    	nbCasesJouees = 0
    	sommeInfo = 0
    	
    	unTab.each{|uneCase|
    	
    		nbCasesJouees += 1 if uneCase.jouee?
    	}
    	
    	desInfos.each{|uneInfo|
    	
    		sommeInfo += uneInfo
    	}
    	
    	return (nbCasesJouees-sommeInfo)
    end
    
	def to_s
		@grille.to_debug
		@plateauJeu.to_debug
		@informations.to_debug
		print grilleValide?
	end
end
