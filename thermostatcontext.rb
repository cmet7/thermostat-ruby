class ThermostatContext

  attr_accessor :statemachine

	def start_cooling
		puts "Starting cooling and fan."
		RELAYS.cool = true
	end

  def stop_cooling
    stop_conditioning
  end

	def start_heating
		puts "Started heating and fan."
		RELAYS.heat = true
	end

	def stop_heating
    stop_conditioning
	end

  def stop_conditioning
		if RELAYS.cool
			puts "Stopped cooling."
			RELAYS.cool = false
		end
		if RELAYS.heat
			puts "Stopped heating."
			RELAYS.heat = false
		end
		puts "Starting 30 second fan period"
    RELAYS.fan = true
		sleep(30)
		RELAYS.fan = false
		puts "Turned fan off."
	end

  def start_fanning
    puts "Starting fan"
    RELAYS.fan = true
  end

  def stop_fanning
    puts "Stopping fan"
    RELAYS.fan = false
  end

	def long_wait
		puts "Tried to switch from heat to cool or cool to heat."
		puts "This should never happen, so we will wait 3 minutes and hope the conditions stabilize"
    RELAYS.fan = true
		sleep(300)
		end_conditioning
	end

  def cooling_decision
    cool_temp = THERMOSTAT.cool_temp
    differential = THERMOSTAT.differential
    cooling_enabled = THERMOSTAT.cooling
    reading = SENSOR.reading

    @statemachine.end_cooling unless cooling_enabled && (reading > cool_temp - differential)
  end

  def heating_decision
    heat_temp = THERMOSTAT.heat_temp
    differential = THERMOSTAT.differential
    heating_enabled = THERMOSTAT.heating
    reading = SENSOR.reading

    @statemachine.end_heating unless heating_enabled && (reading < heat_temp + differential)
  end

  def idle_or_fan_decision
    heat_temp = THERMOSTAT.heat_temp
    cool_temp = THERMOSTAT.cool_temp
    heating_enabled = THERMOSTAT.heating
    cooling_enabled = THERMOSTAT.cooling
    reading = SENSOR.reading

    
    if (heat_temp > reading && heating_enabled)
      puts "reading #{reading} < heat_temp #{heat_temp} so going to decision mode"
      @statemachine.start_conditioning
    elsif (reading > cool_temp && cooling_enabled)
      puts "reading #{reading} >  cool_temp #{cool_temp} so going to decision mode"
      @statemachine.start_conditioning
    end
  end

  def mode_decision
    heat_temp = THERMOSTAT.heat_temp
    cool_temp = THERMOSTAT.cool_temp
    heating_enabled = THERMOSTAT.heating
    cooling_enabled = THERMOSTAT.cooling
    fan_enabled = THERMOSTAT.fan
    reading = SENSOR.reading
    if cooling_enabled && reading > cool_temp
      puts "Had to start cooling"
      @statemachine.do_cooling
    elsif heating_enabled && reading < heat_temp
      puts "Had to start heating"
      @statemachine.do_heating
    elsif fan_enabled
      puts "Had to start fan"
      @statemachine.do_fanning
    else
      puts "Nothing else to do, going idle"
    end
  end
  
end
