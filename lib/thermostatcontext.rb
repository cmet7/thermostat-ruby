module Thermostat
  class ThermostatContext

    attr_accessor :statemachine

    def start_cooling
      Logger.log "Starting cooling"
      Relays.cool = true
    end

    def stop_cooling
      Logger.log "Stopping cooling"
      stop_conditioning
    end

    def start_heating
      Logger.log "Started heating"
      Relays.heat = true
    end

    def stop_heating
      stop_conditioning
    end

    def stop_conditioning
      if Relays.cool
        Logger.log "Stopped cooling."
        Relays.cool = false
      end
      if Relays.heat
        Logger.log "Stopped heating."
        Relays.heat = false
      end
      Logger.log "Starting 30 second fan period"
      Relays.fan = true
      sleep(30)
      Relays.fan = false
      Logger.log "Turned fan off."
    end

    def start_fanning
      Logger.log "Starting fan"
      Relays.fan = true
    end

    def stop_fanning
      Logger.log "Stopping fan"
      Relays.fan = false
    end

    def long_wait
      Logger.log "Tried to switch from heat to cool or cool to heat."
      Logger.log "This should never happen, so we will wait 3 minutes and hope the conditions stabilize"
      Relays.fan = true
      sleep(300)
      end_conditioning
    end

    def cooling_decision
      settings = Settings.get_settings
      heat_temp = settings["heat_temp"]
      cool_temp = settings["cool_temp"]
      differential = settings["differential"]
      heating_enabled = settings["heating_enabled"]
      cooling_enabled = settings["cooling_enabled"]
      fan_enabled = settings["fan_enabled"]
      reading = Sensor.temp

      @statemachine.end_cooling unless cooling_enabled && (reading > cool_temp - differential)
    end

    def heating_decision
      settings = Settings.get_settings
      heat_temp = settings["heat_temp"]
      cool_temp = settings["cool_temp"]
      differential = settings["differential"]
      heating_enabled = settings["heating_enabled"]
      cooling_enabled = settings["cooling_enabled"]
      fan_enabled = settings["fan_enabled"]
      reading = Sensor.temp

      @statemachine.end_heating unless heating_enabled && (reading < heat_temp + differential)
    end

    def idle_or_fan_decision
      settings = Settings.get_settings
      heat_temp = settings["heat_temp"]
      cool_temp = settings["cool_temp"]
      heating_enabled = settings["heating_enabled"]
      cooling_enabled = settings["cooling_enabled"]
      fan_enabled = settings["fan_enabled"]
      reading = Sensor.temp

      
      if (heat_temp > reading && heating_enabled)
        Logger.log "reading #{reading} < heat_temp #{heat_temp} so going to decision mode"
        @statemachine.start_conditioning
      elsif (reading > cool_temp && cooling_enabled)
        Logger.log "reading #{reading} >  cool_temp #{cool_temp} so going to decision mode"
        @statemachine.start_conditioning
      end
    end

    def mode_decision
      settings = Settings.get_settings
      heat_temp = settings["heat_temp"]
      cool_temp = settings["cool_temp"]
      heating_enabled = settings["heating_enabled"]
      cooling_enabled = settings["cooling_enabled"]
      fan_enabled = settings["fan_enabled"]
      reading = Sensor.temp
      if cooling_enabled && reading > cool_temp
        Logger.log "Had to start cooling"
        @statemachine.do_cooling
      elsif heating_enabled && reading < heat_temp
        Logger.log "Had to start heating"
        @statemachine.do_heating
      elsif fan_enabled
        Logger.log "Had to start fan"
        @statemachine.do_fanning
      else
        Logger.log "Nothing else to do, going idle"
      end
    end
    
  end
end
