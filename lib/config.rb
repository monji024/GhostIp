require 'yaml'

module GhostIp
  class Config
    DEFAULTS = {
      'proxy_addr'      => '127.0.0.1',
      'proxy_port'      => 9050,
      'control_port'    => 9051,
      'check_urls'      => [
        'http://checkip.amazonaws.com',
        'https://api.ipify.org',
        'https://icanhazip.com',
        'https://ifconfig.me/ip'],
      'geo_url'         => 'http://ip-api.com/json/',
      'interval'        => 60,
      'count'           => 0,
      'max_retries'     => 3,
      'retry_backoff'   => 2,
      'log_file'        => '/tmp/ghostip.log',
      'kill_switch'     => false,
      'notify_on_fail'  => true}.freeze
    attr_reader :data
    def self.load(path = nil)
      new(path)
    end

    def initialize(path)
      @data = DEFAULTS.dup
      if path && File.exist?(path)
        begin
          user_cfg = YAML.safe_load(File.read(path)) || {}
          @data.merge!(user_cfg)
        rescue Psych::SyntaxError => e
          warn "config parse error, falling back to defaults (#{e.message})"
        end
      end
    end
    def [](key)
      @data[key.to_s]
    end
    def []=(key, value)
      @data[key.to_s] = value
    end
    def to_h
      @data
    end
  end
end
