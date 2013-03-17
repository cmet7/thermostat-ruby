class Thermostat
	attr_reader :cool_temp, :heat_temp, :differential, :cooling, :heating, :fan, :t

	def initialize

		@thermostat = Statemachine.build do 
      superstate :operational do


        event :set_heat_temp, :idle, :set_heat_temp

        state :waiting_for_config do
          on_entry Proc.new{ "Waiting for configuration" }

          on_exit Proc.new{ "Got configuration, waiting..." }
        end

        state :idle do
          on_entry Proc.new{ puts "Starting idle" }
          event :clock, :idle, :idle_or_fan_decision
          event :start_conditioning, :decide_mode
          on_exit Proc.new{ puts "Ending idle" }
        end

        state :cooling do
          on_entry :start_cooling
          event :clock, :cooling, :cooling_decision
          event :end_cooling, :decide_mode
          on_exit :stop_cooling
        end
      
        state :heating do
          on_entry :start_heating
          event :clock, :heating, :heating_decision
          event :end_heating, :decide_mode
          on_exit :stop_heating
        end

        state :fanning do
          on_entry :start_fanning
          event :clock, :fanning, :idle_or_fan_decision
          event :start_conditioning, :decide_mode
          on_exit :stop_fanning
        end

        state :decide_mode do
          on_entry :mode_decision
          event :do_idling, :idle
          event :do_cooling, :cooling
          event :do_heating, :heating
          event :do_fanning, :fanning
          on_exit Proc.new{ puts "Made decision" }
        end
      end

    	context ThermostatContext.new
    end

    config_file = YAML.load_file(File.join(File.dirname(__FILE__), "settings.yaml"))

    @thermostat.context.instance_exec{ @heat_temp = 60 }
    raise @thermostat.context.instance_eval { @heat_temp }.inspect


#    @thermostat.cool_temp = config_file["cool_temp"]
    @thermostat.set_heat_temp config_file["heat_temp"]
#    @thermostat.differential = config_file["differential"]
#    @thermostat.cooling = config_file["cooling"]
#    @thermostat.heating = config_file["heating"]
#    @thermostat.fan = config_file["fan"]

	end

  def set_heat_temp temp

  end

  def get_heat_temp
    @thermostat.heat_temp
  end

  def set_cool_temp= temp
    if (temp - @thermostat.differential) > @thermostat.heat_temp
      @thermostat.cool_temp = temp
      return true
    else
      return false
    end
  end

  def differential= degrees
    if (@thermostat.heat_temp + ( 2 * degrees )) < @thermostat.cool_temp
      @thermostat.differential = degrees
      return true
    else
      return false
    end
  end

	private

	def between reading, lower, upper
		reading >= lower && reading <= upper
	end

end
