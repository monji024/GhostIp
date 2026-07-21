require 'socksify/http'
require 'json'
require 'uri'

module GhostIp
  class IpLookup
    class AllEndpointsFailed < StandardError; end

    def initialize(config, logger)
      @config = config
      @logger = logger
      @proxy_addr = config['proxy_addr']
      @proxy_port = config['proxy_port']
      @urls = config['check_urls']
      @max_retries = config['max_retries']
      @backoff = config['retry_backoff']
    end

    def current_ip
      last_err = nil
      @urls.each do |url|
        attempt = 0
        begin
          attempt += 1
          ip = fetch(url)
          return ip.strip if ip && !ip.strip.empty?
        rescue StandardError => e
          last_err = e
          if attempt < @max_retries
            sleep(@backoff * attempt)
            retry
          end
          @logger.warn("endpoint failed #{url} -> #{e.message}")
          next
        end
      end
      raise AllEndpointsFailed, last_err&.message.to_s
    end

    def geo_info(ip)
      return {} if ip.nil? || ip.empty?
      uri = URI("#{@config['geo_url']}#{ip}")
      proxy = Net::HTTP.SOCKSProxy(@proxy_addr, @proxy_port)
      req = Net::HTTP::Get.new(uri)
      res = proxy.start(uri.host, uri.port, read_timeout: 6) { |http| http.request(req) }
      JSON.parse(res.body)
    rescue StandardError
      {}
    end

    private

    def fetch(url)
      uri = URI(url)
      proxy = Net::HTTP.SOCKSProxy(@proxy_addr, @proxy_port)
      req = Net::HTTP::Get.new(uri)
      res = proxy.start(uri.host, uri.port, read_timeout: 8) { |http| http.request(req) }
      raise "http #{res.code}" unless res.code.to_i == 200
      res.body
    end
  end
end
