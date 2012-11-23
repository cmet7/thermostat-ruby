class Relays
	attr_accessor :heat, :cool, :fan

	def initialize
		super
		@heat, @cool, @fan = false, false, false
	end
	
end
