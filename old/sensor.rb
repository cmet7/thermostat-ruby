class Sensor
  # this class just returns the sensor reading

#  def reading
#    # using linux to poll sensor via lm-sensors and grep/awk to return a float
#	  `sensors -f | grep temp1 | awk '{print $2}'`[/[0-9]{1,3}\.[0-9]+/].to_f
#  end

  # for debug
  attr_accessor :reading

  def initialize
    @reading = 75
  end
end
