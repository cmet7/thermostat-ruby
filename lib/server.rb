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
      else # can't daemonize
        Thermostat::Logger.error_log "Unable to daemonize process"
      end
    end

    private

    def check_pid!
      case pidfile_process_status
      when :running, :not_owned
        Thermostat::Logger.error_log "A server is already running. Check #{@pid_file}."
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

  end # Server

end
