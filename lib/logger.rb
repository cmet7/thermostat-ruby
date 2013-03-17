module Thermostat
  module Logger

    @@log_file = File.new "thermostat.log", "a"

    def self.log message
      $stderr.puts message
      @@log_file.puts "[#{Time.now}] #{message}"
    end

    def self.error_log message
      self.log "ERROR: #{message}"
    end
    
  end
  
end
