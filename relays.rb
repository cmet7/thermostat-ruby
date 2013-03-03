class Relays
	attr_reader :heat, :cool, :fan

	PINS = { :fan => 17, :cool => 21, :heat => 22 }

	def initialize
		super
		@heat, @cool, @fan = false, false, false
		set_all_relays
	end

	def heat= value
		@heat = value
		set_all_relays
	end

	def cool= value
		@cool= value
		set_all_relays
	end
	
	def fan= value
		@fan = value
		set_all_relays
	end

	def set_relay(relay, val)
		puts "Setting relay"
		value = val ? 1 : 0	
		`echo "#{value}" > /sys/class/gpio/gpio#{PINS[relay]}/value`
		puts "echo \"#{value}\" > /sys/class/gpio/gpio#{PINS[relay]}/value"
	end

	def set_all_relays
		set_relay(:heat, @heat)
		set_relay(:cool, @cool)
		set_relay(:fan, @fan)
	end

end
