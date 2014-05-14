#La classe timer stocke un temps qu'elle incrémente chaque seconde lorsque son thread est lancé
class Timer
		
		@temps
		
		@label
		@profil		
	
		@thread


		attr_writer :label
		attr_reader :temps

		def initialize(unTemps=0, profil)

			@temps = unTemps
			@profil = profil
		end 

		#Le le thread chargé d'actualiser le timer lors d'une partie
		def lancerTimer
		
			@thread = Thread.start {
				while true
					sleep 1
					@profil.getStats["temps_joue"] +=1
					@temps +=1
					setLabel
				end
			}

		end 

		#Arrête le thread timer
		def stopperTimer
		
			@thread.kill
		end

		#Met à jour le label à partir des variables d'instances désignant le temps
		def setLabel
	
			@label.set_label(to_s)
			@label.show
		end
		
		def to_s
		
			heures = @temps/3600
			minutes = (@temps - (heures*3600)) / 60
			secondes = @temps - (heures*3600) - (minutes*60)
			
			h = heures < 10 ? "0" + heures.to_s : heures.to_s
			m = minutes < 10 ? "0" + minutes.to_s : minutes.to_s
			s = secondes < 10 ? "0" + secondes.to_s : secondes.to_s
			
			return h + ":" + m + ":" + s
			
		end
end
