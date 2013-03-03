class ThermostatContext

	def start_cooling
		puts "Starting cooling and fan."
		RELAYS.fan = true
		RELAYS.cool = true
	end

	def end_conditioning
		if RELAYS.cool
			puts "Stopped cooling."
			RELAYS.cool = false
		end
		if RELAYS.heat
			puts "Stopped heating."
			RELAYS.heat = false
		end
		puts "Starting 15 second fan period"
		sleep(15)
		RELAYS.fan = false
		puts "Turned fan off."
	end

	def start_heating
		puts "Started heating and fan."
		RELAYS.fan = true
		RELAYS.heat = true
	end

	def end_heating
		puts "Stopped heating."
		RELAYS.heat = false
	end

	def long_wait
		puts "Tried to switch from heat to cool or cool to heat."
		puts "This should never happen, so we will wait 3 minutes and hope the conditions stabilize"
		sleep(300)
		end_conditioning
	end
end

