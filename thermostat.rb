#!/usr/bin/env ruby

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "lib/server.rb"
require "lib/logger.rb"

Thermostat::Server.new

