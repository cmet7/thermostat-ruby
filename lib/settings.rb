module Thermostat
  module Settings
    require 'yaml'
    @mutex = Mutex.new
    
    def self.get_settings
      @mutex.synchronize do
        unless @settings
          yaml_settings = YAML.load(File.open("#{ENV['PWD']}/config/settings.yml"))
          # convert to hash
          @settings = {}
          yaml_settings.keys.each do |key|
            @settings[key] = yaml_settings[key]
          end
        end
        @settings
      end
    end

    def self.update_settings settings
      @mutex.synchronize do
        settings.keys.each do |key|
          # update if settings already exist in @settings
          @settings[key] = settings[key] if @settings.keys.include?(key)
        end
      end
    end
    
  end
end
