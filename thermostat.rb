class Thermostat
	attr_reader :cool_temp, :heat_temp, :differential, :cooling, :heating, :fan, :t

	def initialize mutex
    @mutex = mutex
    load_yaml

		@t = Statemachine.build do 
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

    	context ThermostatContext.new
    end
	end

  def set_heat_temp= temp
    if (temp + differential) < @cool_temp
      @heat_temp = temp
      config_change
      return true
    else
      return false
    end
  end

  def set_cool_temp= temp
    if (temp - differential) > @heat_temp
      @cool_temp = temp
      config_change
      return true
    else
      return false
    end
  end

  def differential= degrees
    if (@heat_temp + ( 2 * degrees )) < @cool_temp
      @differential = degrees
      config_change
      return true
    else
      return false
    end
  end

  def clock
    load_yaml
    @t.clock
  end

  def config_change
    load_yaml
    @t.clock
  end

  def load_yaml
    @mutex.synchronize do
      config_file = YAML.load_file(File.join(File.dirname(__FILE__), "settings.yaml"))

      @cool_temp = config_file["cool_temp"]
      @heat_temp = config_file["heat_temp"]
      @differential = config_file["differential"]
      @cooling = config_file["cooling"]
      @heating = config_file["heating"]
      @fan = config_file["fan"]
    end
  end

	private

	def between reading, lower, upper
		reading >= lower && reading <= upper
	end
end
