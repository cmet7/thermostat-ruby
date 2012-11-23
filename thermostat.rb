class Thermostat
	attr_accessor :cool_temp, :heat_temp
	DIFFERENTIAL = 3.0

	def initialize
		@cool_temp = 78.0
		@heat_temp = 68.0
		@t = Statemachine.build do 
    	state :idle do
    		event :too_hot, :cooling
    		event :comfortable, :idle
    		event :too_cold, :heating
    	end

    	state :cooling do
    		on_entry :start_cooling
    		event :too_hot, :cooling
    		event :comfortable, :idle, :end_conditioning
    		event :too_cold, :idle, :long_wait
    	end
    
    	state :heating do
    		on_entry :start_heating
    		event :too_hot, :idle, :long_wait
    		event :comfortable, :idle, :end_conditioning
    		event :too_cold, :heating
    	end
    	context ThermostatContext.new
    end
	end

	def check_temperature reading
		if between(reading, @cool_temp - DIFFERENTIAL, @cool_temp) || 
				between(reading, @heat_temp, @heat_temp + DIFFERENTIAL)
			puts "We are in the dead zone"
			# do nothing
		elsif reading > @cool_temp
			@t.too_hot
		elsif reading < @heat_temp
			@t.too_cold
		else
			@t.comfortable
		end
	end

	private

	def between reading, lower, upper
		reading >= lower && reading <= upper
	end
end
