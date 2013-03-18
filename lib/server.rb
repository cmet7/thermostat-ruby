module Thermostat

  class Server

    def initialize
      @pid_filename = "/var/run/thermostat.pid"
      self.start
    end

    def start
      if Process.daemon
        Thermostat::Logger.log "Server initialized, pid #{Process.pid.to_s}"
        check_pid!
        write_pid
        trap(:SIGTERM) { Thermostat::Logger.log "Received SIGTERM, shutting down" }
        while true
          sleep 10
        end
      else # can't daemonize
        Thermostat::Logger.error_log "Unable to daemonize process"
      end
    end

    private

    def check_pid!
      case pidfile_process_status
      when :running, :not_owned
        Thermostat::Logger.error_log "A server is already running. Check #{@pid_filename}."
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

  end # Server

end
