#!/usr/bin/env ruby

require 'statemachine'
require './relays.rb'
require './ThermostatContext.rb'


RELAYS = Relays.new

THERMOSTAT = Statemachine.build do 

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


