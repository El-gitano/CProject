ENCOURS = 0
FINI = 1
ENPAUSE = 2

class Timer

		@timer
		@statutJeu
		@label

		attr_writer :label

		def initialize(unTemps=0)

			@timer = unTemps
		end 

		def lancerTimer
			@statutJeu = ENCOURS
			Thread.start {
				begin
					sleep 1
					@timer +=1
					heures = @timer / 3600	
					minutes = (@timer - (heures*3600)) / 60
					secondes = @timer - heures*3600 - minutes*60
					@label.set_label(heures.to_s + ":" + minutes.to_s + ":" + secondes.to_s)
					@label.show
			
				end until @statutJeu != ENCOURS
			}

		end 

		def stopperTimer
			@statutJeu = FINI	
		end

		def mettreEnPause
			@statutJeu = ENPAUSE	
		end

end
