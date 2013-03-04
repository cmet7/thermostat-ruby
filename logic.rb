#!/usr/bin/env ruby

require 'statemachine'
require 'yaml'
require './relays.rb'
require './sensor.rb'
require './thermostat.rb'
require './thermostatcontext.rb'

RELAYS = Relays.new
SENSOR = Sensor.new
MUTEX = Mutex.new
THERMOSTAT = Thermostat.new(MUTEX)

clock_thread = Thread.new do
  while true do
    THERMOSTAT.clock
    puts "tick..."
    sleep 10
  end
end
