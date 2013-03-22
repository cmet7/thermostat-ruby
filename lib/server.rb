module Thermostat

  class Server

    def initialize
      @pid_filename = "/var/run/thermostat.pid"
      self.start
    end

    def start
      check_pid!
      at_exit { Logger.log "Server stopped. (PID: #{Process.pid.to_s})" }


      if Process.daemon
        begin
          Logger.log "Server initialized, pid #{Process.pid.to_s}"
          write_pid

          # Start state machine
          @machine = Thermostat.new

          # Start listening on socket
          Logger.log "Starting socket server. (PID: #{SocketServer.new})"

          # Trap SIGTERM to log shutdown message
          trap(:SIGTERM) do
            Logger.log "Received SIGTERM, shutting down"
            exit(0)
          end

          # Trap SIGUSR1 to clock statemachine
          trap(:USR1) do
            # clock statemachine
            Logger.log "Clocking statemachine"
            @machine.clock
            Logger.log "After clocking: #{@machine.inspect}"
          end

          trap :USR2 do
            Logger.log Settings.get_settings.inspect
            Logger.log @machine.inspect
          end

          while true
            # clock statemachine
            sleep 1
          end

        rescue Exception => e
          Logger.log_exception(e)
        end
      else # can't daemonize
        Logger.error_log "Unable to daemonize process"
      end
    end

    private

    def check_pid!
      case pidfile_process_status
      when :running, :not_owned
        Logger.error_log "Tried to start server; It's already running. Check #{@pid_filename}."
        exit(1)
      when :dead
        ::File.delete(@pid_filename)
      end
    end

    def pidfile_process_status
      return :exited unless ::File.exist?(@pid_filename)

      pid = ::File.read(@pid_filename).to_i
      Process.kill(0, pid)
      :running
    rescue Errno::ESRCH
      :dead
    rescue Errno::EPERM
      :not_owned
    end

    def write_pid
      ::File.open(@pid_filename, ::File::CREAT | ::File::EXCL | ::File::WRONLY ) { |f| f.write("#{Process.pid}") }
      at_exit { ::File.delete(@pid_filename) if ::File.exist?(@pid_filename) }
    rescue Errno::EEXIST
      check_pid!
      retry
    end

    def check_socket!
      
    end

  end # Server

end
