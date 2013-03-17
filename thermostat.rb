#!/usr/bin/env ruby

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}")
require "lib/server.rb"
require "lib/logger.rb"

begin
  t = Thermostat::Server.new
rescue Exception => e
  Thermostat::Logger.error_log "#{e.to_s}\n\t#{e.backtrace.join("\n\t")}"
end

