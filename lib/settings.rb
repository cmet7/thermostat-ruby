module Thermostat
  module Settings
    require 'yaml'
    @mutex = Mutex.new

    def self.get_settings
      @mutex.synchronize do
        @settings ||= self.load_yaml
        @settings
      end
    end

    def self.update_settings settings
      @mutex.synchronize do
        @settings ||= self.load_yaml
        settings.keys.each do |key|
          # update if settings already exist in @settings
          @settings[key] = settings[key] if @settings.keys.include?(key)
        end
      end
      Logger.log "Updated settings: #{@settings}"
    end
    
    private

    def self.load_yaml
      yaml_settings = YAML.load(File.open("#{ENV['PWD']}/config/settings.yml"))
      # convert to hash
      @settings = {}
      Logger.log "Loading settings from config/settings.yml"
      yaml_settings.keys.each do |key|
        @settings[key] = yaml_settings[key]
        Logger.log "\t#{key}: #{@settings[key]}"
      end
      @settings
    end
  end
end
