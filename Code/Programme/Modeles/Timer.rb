#La classe timer stocke un temps qu'elle incrémente chaque seconde lorsque son thread est lancé
class Timer

		ENCOURS = 0
		FINI = 1
		ENPAUSE = 2
		
		@tempsOrigine
		@temps
		
		@statutJeu
		@label
		@profil		
	
		@thread
		
		@heures
		@minutes
		@secondes

		attr_writer :label
		attr_reader :temps, :tempsOrigine

		def initialize(unTemps=0, profil)

			@tempsOrigine = unTemps
			@temps = tempsOrigine
			@profil = profil
		end 

		#Le le thread chargé d'actualiser le timer lors d'une partie
		def lancerTimer
		
			@thread = Thread.start {
				while true
					sleep 1
					@profil.getStats["temps_joue"] +=1
					@temps +=1
					getTime
					setLabel
				end
			}

		end 

		#Arrête le thread timer
		def stopperTimer
		
			@thread.kill
		end

		#Récupère les informations temporelles sous forme d'entiers
		def getTime
		
			@heures = @temps/3600
			@minutes = (@temps - (@heures*3600)) / 60
			@secondes = @temps - (@heures*3600) - (@minutes*60)
		end
		
		#Met à jour le label à partir des variables d'instances désignant le temps
		def setLabel

			h = @heures < 10 ? "0" + @heures.to_s : @heures.to_s
			m = @minutes < 10 ? "0" + @minutes.to_s : @minutes.to_s
			s = @secondes < 10 ? "0" + @secondes.to_s : @secondes.to_s
			
			@label.set_label(h + ":" + m + ":" + s)
			@label.show
		end
end
