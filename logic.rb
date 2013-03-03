#!/usr/bin/env ruby

require 'statemachine'
require './relays.rb'
require './thermostat.rb'
require './thermostatcontext.rb'

RELAYS = Relays.new
THERMOSTAT = Thermostat.new

while true do
	#reading = gets.chomp.to_f
	reading = `sensors -f | grep temp1 | awk '{print $2}'`[/[0-9]{1,3}\.[0-9]+/].to_f
	THERMOSTAT.check_temperature reading
	puts "Current temperature: #{reading}"
	puts RELAYS.inspect
	puts ""
	sleep 10
end
