#!/usr/bin/env ruby
# author : Monji
# telegram : https://t.me/DevCrr
# GitHub : https://github.com/monji024


$stdout.sync = true
Signal.trap("INT") { puts "\n\u001b[1;31m ended \u001b[0m"; exit }

class GhostIp
  PROXY_ADDR = '127.0.0.1'.freeze
  PROXY_PORT = 9050.freeze
  CHECK_URI  = 'http://checkip.amazonaws.com'.freeze
  
  def initialize
    @signature = [
      """
    ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗ ██╗██████╗ 
    ██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝ ██║██╔══██╗
    ██║  ███╗███████║██║   ██║███████╗   ██║    ██║██████╔╝
    ██║   ██║██╔══██║██║   ██║╚════██║   ██║    ██║██╔═══╝ 
    ╚██████╔╝██║  ██║╚██████╔╝███████║   ██║    ██║██║     
    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝    ╚═╝╚═╝     
\n"""
    ].join("\n")
  end

  def display_header
    system("clear") || system("cls")
    puts @signature
    puts "tor proxy: \u001b[1;33m#{PROXY_ADDR}:#{PROXY_PORT}\u001b[0m"
    puts "status: \u001b[1;32mACTIVE\u001b[0m"

  end

  def daemon_spawn
    `sudo service tor start 2>/dev/null`
    sleep(2)
    puts "\u001b[1;32m  ✓ Daemon online\u001b[0m"
  end

  def fetch_masked_ip
    begin
      require 'socksify/http'
      proxy = Net::HTTP.SOCKSProxy(PROXY_ADDR, PROXY_PORT)
      uri = URI(CHECK_URI)
      req = Net::HTTP::Get.new(uri)
      res = proxy.start(uri.host, uri.port, read_timeout: 8) { |http| http.request(req) }
      res.body.strip
    rescue => e
      "err: #{e.message}\u001b[0m"
    end
  end

  def rotate_identity
    `sudo service tor reload 2>/dev/null`
    sleep(1)
    new_ip = fetch_masked_ip
    puts "\u001b[1;32m  ➤ \u001b[1;37m#{new_ip}\u001b[0m"
    
    File.open("/tmp/ghost.log", "a") do |log|
      log.puts("[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] IP: #{new_ip}")
    end
    
    new_ip
  end

  def engage
    display_header
    daemon_spawn
    current = fetch_masked_ip
    
    if current.include?("ERROR")
      print
    else
      puts "\u001b[1;32m  ✓ Active channel : \u001b[1;37m#{current}\u001b[0m"
    end
    
    puts "\u001b[1;30m    ──────────────────────────────────────────────────\u001b[0m\n\n"
    
    print "\u001b[1;36m   ? rotation interval (sec) [30]: \u001b[0m"
    interval = gets.chomp
    interval = interval.empty? ? 60 : interval.to_i
    
    print "\u001b[1;36m   ? rotation count (0 = ∞): \u001b[0m"
    count = gets.chomp
    count = count.empty? ? 0 : count.to_i
    
    puts "\n   exit -> press CTRL+C \u001b[0m"
    
    if count.zero?
      loop do 
        sleep(interval)
        rotate_identity
      end
    else
      count.times do |i|
        sleep(interval)
        rotate_identity
        puts "\u001b[1;30m  * progress : [#{i+1}/#{count}] COMPLETE\u001b[0m"
      end
      puts "\n\u001b[1;32m   ✓ All rotations completed\u001b[0m"
    end
  end
end

if __FILE__ == $0
  _ip = GhostIp.new
  _ip.engage
end
