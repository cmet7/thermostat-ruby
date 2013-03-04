#!/usr/bin/env ruby

require 'statemachine'
require './relays.rb'
require './sensor.rb'
require './thermostat.rb'
require './thermostatcontext.rb'

RELAYS = Relays.new
SENSOR = Sensor.new
THERMOSTAT = Thermostat.new


