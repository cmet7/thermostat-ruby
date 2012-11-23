class Relays
	attr_reader :heat, :cool, :fan

	def initialize
		super
		@heat, @cool, @fan = false, false, false
	end

	def heat= value
		@heat = value
		# update relay here
	end

	def cool= value
		@cool= value
		# update relay here
	end
	
	def fan= value
		@fan = value
		# update relay here
	end
end
