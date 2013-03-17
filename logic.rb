#!/usr/bin/env ruby

require 'statemachine'
require 'yaml'
require './relays.rb'
require './sensor.rb'
require './thermostat.rb'
require './thermostatcontext.rb'

pid_filename = "thermostat.pid"
log_file = File.new "error.log", "a"

if true

#  if File.exist?(pid_filename)
#    log_file.puts "Process already running. If it`s not - remove the pid file"
#    exit
#  end
#
#  begin
#    pid_file = File.new(pid_filename, "w")
#    pid_file.puts Process.pid.to_s
#  rescue Errno::EACCES
#    log_file.puts "Couldn't open pid file for writing"
#    exit
#  end

  RELAYS = Relays.new
  SENSOR = Sensor.new
  @thermostat = Thermostat.new
  puts @thermostat.heat_temp
  @thermostat.set_heat_temp 100
  puts @thermostat.heat_temp

#  while true do
#    @thermostat.clock
#    sleep 1
#  end

else
  puts "Failed to daemonize process"
end
