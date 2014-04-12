class Plateau

	@grille
	@nbJokers
	@nom
	
	private_class_method :new
	
	def enleverJoker
	
		@nbJokers -= 1
	end
end
