module GhostIp
  class Stats
    attr_reader :started_at, :rotations, :failures, :ip_history
    def initialize
      @started_at = Time.now
      @rotations = 0
      @failures = 0
      @ip_history = []
    end
    def record_success(ip)
      @rotations += 1
      @ip_history << ip
      @ip_history.shift if @ip_history.size > 50
    end
    def record_failure
      @failures += 1
    end
    def uptime
      Time.now - @started_at
    end
    def unique_ip_count
      @ip_history.uniq.size
    end
    def summary
      {
        uptime_seconds: uptime.round,
        rotations: @rotations,
        failures: @failures,
        unique_ips: unique_ip_count}
    end
  end
end
