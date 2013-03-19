module Thermostat

  require 'statemachine'

  class Thermostat

    def initialize

      @t = Statemachine.build do 
        state :idle do
          on_entry Proc.new{ Logger.log "Starting idle" }
          event :clock, :idle, :idle_or_fan_decision
          event :start_conditioning, :decide_mode
          on_exit Proc.new{ Logger.log "Ending idle" }
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

    def clock
      @t.clock
    end

  end
end
