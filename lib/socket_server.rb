module Thermostat
  require 'eventmachine'
  require 'base64'

  class SocketServer

    def initialize
      Logger.log "Initializing event machine"
      Thread.new do
        EventMachine.run do
          EventMachine.start_server("/tmp/thermostat.sock", ServerConnection)
        end
      end
    end

    
  end

  class ServerConnection < EM::Connection
    def post_init
      Logger.log "Connection initiated"
    end

    def receive_data data
      Logger.log "Connection received data: #{data}"
      decoded_data = Base64.decode64(data)
      Logger.log "Decoded data: #{Marshal.load decoded_data}"
      # update settings
      begin
        Settings.update_settings(Marshal.load(decoded_data))
      rescue TypeError => e
        Logger.error_log e
      end
      #Process.kill "USR1", Process.ppid
    end

    def unbind
      Logger.log "Connection closed"
    end

  end
end
