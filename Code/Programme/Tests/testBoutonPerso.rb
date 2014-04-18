require 'gtk2'

class BoutonPerso < Gtk::Button

	@x
	@y
	
	attr_reader :x, :y
	
	def BoutonPerso.new(unX, unY)
	
		super()
		@x = unX
		@y = unY
	end
	
	def to_s
	
		return "#{@x} et #{@y}"
	end
end

b = BoutonPerso.new(0, 4)
b2 = BoutonPerso.new(1, 8)
puts b.to_s
puts b2
