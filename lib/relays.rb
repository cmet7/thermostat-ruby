module Thermostat
  module Relays
    @fan = false
    @heat = false
    @cool = false

    def self.cool
      @cool
    end

    def self.cool= val
      @cool = val
    end

    def self.heat
      @heat
    end

    def self.heat= val
      @heat = val
    end

    def self.fan
      @fan
    end

    def self.fan= val
      @fan = val
    end

  end
end
