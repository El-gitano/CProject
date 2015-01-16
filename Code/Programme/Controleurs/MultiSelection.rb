		#On connecte les signaux clic et passage aux cases
		@vue.table.each{|uneCase|
		
			#Changement d'état lors d'un clic
			uneCase.signal_connect("button_press_event"){|laCase, event|
		
				#On relâche le clic
				Gdk::Display.default.pointer_ungrab(Gdk::Event::CURRENT_TIME)
				
				#Màj stats
				@modele.ajouterClic
				
				# Si clic gauche
				if (event.button == 1) then
	
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicGauche
					
				# Si clic droit
				elsif (event.button == 3) then
		
					@modele.plateauJeu.getCase(laCase.x, laCase.y).clicDroit		
				end
				
				lancerVerification
				@vue.actualiserCase(laCase.x, laCase.y)	
			}
			
			#Lors du passage de la souris on vérifie qu'on a pas un bouton de la souris appuyé
			uneCase.signal_connect("enter-notify-event"){|laCase, event|
				
				if event.state == Gdk::Window::BUTTON1_MASK
				
					@modele.getCase(laCase.x, laCase.y).clicGauche
					@modele.ajouterClic
					lancerVerification
					@vue.actualiserCase(laCase.x, laCase.y)
					
				elsif event.state == Gdk::Window::BUTTON3_MASK
				
					@modele.getCase(laCase.x, laCase.y).clicDroit
					@modele.ajouterClic
					lancerVerification
					@vue.actualiserCase(laCase.x, laCase.y)
				end
			}
		}
		
