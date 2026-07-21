require 'socket'
require 'timeout'

module GhostIp
  class TorController
    def initialize(config, logger)
      @config = config
      @logger = logger
      @addr = config['proxy_addr']
      @port = config['proxy_port']
    end
    def start
      `sudo service tor start 2>&1`
      unless $?.success?
        `sudo systemctl start tor 2>&1`
      end
      wait_for_port
    end
    def reload
      `sudo service tor reload 2>&1`
      unless $?.success?
        `sudo systemctl reload tor 2>&1`
      end
      sleep(2.5)
    end
    def stop
      `sudo service tor stop 2>&1`
    end
    def running?
      port_open?
    end
    private
    def wait_for_port(tries = 10)
      tries.times do
        return true if port_open?
        sleep 1
      end
      false
    end

    def port_open?
      Timeout.timeout(2) do
        s = TCPSocket.new(@addr, @port)
        s.close
        true
      end
    rescue StandardError
      false
    end
  end
end
