#!/usr/bin/env ruby

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "lib/server.rb"
require "lib/logger.rb"
require "lib/settings.rb"
require "lib/relays.rb"
require "lib/thermostat.rb"
require "lib/thermostatcontext.rb"
require "lib/sensor.rb"

Thermostat::Server.new
