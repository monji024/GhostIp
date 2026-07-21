module GhostIp
  class KillSwitch
    def initialize(config, logger)
      @config = config
      @logger = logger
      @enabled = false
    end

    def enable
      return if @enabled
      cmds = [
        "iptables -F",
        "iptables -P OUTPUT DROP",
        "iptables -A OUTPUT -o lo -j ACCEPT",
        "iptables -A OUTPUT -p tcp --dport #{@config['proxy_port']} -j ACCEPT",
        "iptables -A OUTPUT -p udp --dport 53 -j ACCEPT"
      ]
      cmds.each { |c| `sudo #{c} 2>&1` }
      @enabled = true
      @logger.ok("kill switch engaged, non-tor traffic blocked")
    end

    def disable
      return unless @enabled
      `sudo iptables -P OUTPUT ACCEPT 2>&1`
      `sudo iptables -F 2>&1`
      @enabled = false
      @logger.info("kill switch disengaged")
    end

    def enabled?
      @enabled
    end
  end
end
