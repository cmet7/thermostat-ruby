#!/usr/bin/env ruby

require 'statemachine'
require './relays.rb'
require './thermostat.rb'
require './thermostatcontext.rb'

RELAYS = Relays.new
THERMOSTAT = Thermostat.new

while true do
	reading = gets.chomp.to_f
	THERMOSTAT.check_temperature reading
	puts RELAYS.inspect
end
