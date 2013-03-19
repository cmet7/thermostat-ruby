module Thermostat
  module Sensor
    def self.temp
      temp = (65..85).to_a.sample
      Logger.log "Random temp is now #{temp}"
      temp
    end
  end
end
