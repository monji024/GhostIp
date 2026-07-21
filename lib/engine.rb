module GhostIp
  class Engine
    def initialize(config, opts)
      @config = config
      @opts = opts
      @logger = Logger.new(config['log_file'], verbose: !opts[:quiet])
      @tor = TorController.new(config, @logger)
      @lookup = IpLookup.new(config, @logger)
      @stats = Stats.new
      @kill_switch = KillSwitch.new(config, @logger)
      @running = true
    end

    def run
      UI.banner('2.0')
      trap_signals

      @logger.info("bootstrapping tor daemon...")
      unless @tor.start
        @logger.error("could not confirm tor is listening on #{@config['proxy_addr']}:#{@config['proxy_port']}")
        @logger.error("check `sudo service tor status` and try again")
        exit(1)
      end
      @logger.ok("tor daemon is up")

      @kill_switch.enable if @config['kill_switch'] || @opts[:kill_switch]

      current = safe_lookup
      UI.status_line('current exit ip', current || 'unknown')
      UI.divider

      interval = @opts[:interval] || (@opts[:yes] ? @config['interval'] : UI.prompt('rotation interval (sec)', @config['interval']).to_i)
      count    = @opts[:count]    || (@opts[:yes] ? @config['count']    : UI.prompt('rotation count, 0 = infinite', @config['count']).to_i)

      puts "\n\e[1;30m press CTRL+C to stop\e[0m\n\n"

      loop_rotations(interval, count)
      shutdown(0)
    end

    private

    def loop_rotations(interval, count)
      i = 0
      while @running && (count.zero? || i < count)
        sleep(interval)
        rotate
        i += 1
        UI.progress(i, count) unless count.zero?
      end
      @logger.ok("all requested rotations complete") unless count.zero?
    end

    def rotate
      @tor.reload
      ip = safe_lookup
      if ip
        @stats.record_success(ip)
        UI.status_line('new identity', ip)
      else
        @stats.record_failure
        @logger.warn("rotation produced no confirmed ip")
      end
    end

    def safe_lookup
      @lookup.current_ip
    rescue IpLookup::AllEndpointsFailed => e
      @logger.error("all check endpoints failed: #{e.message}")
      nil
    end

    def trap_signals
      Signal.trap('INT')  { shutdown(0) }
      Signal.trap('TERM') { shutdown(0) }
    end

    def shutdown(code)
      @running = false
      @kill_switch.disable if @kill_switch.enabled?
      s = @stats.summary
      puts "\n\e[1;31m stopped\e[0m"
      UI.status_line('uptime (s)', s[:uptime_seconds])
      UI.status_line('rotations', s[:rotations])
      UI.status_line('failures', s[:failures])
      UI.status_line('unique ips', s[:unique_ips])
      exit(code)
    end
  end
end
