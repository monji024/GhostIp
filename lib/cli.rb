require 'optparse'

module GhostIp
  class Cli
    def self.parse(argv)
      opts = {}
      parser = OptionParser.new do |o|
        o.banner = "usage: ghostip [options]"
        o.on('-c', '--config PATH', 'path to config.yml') { |v| opts[:config] = v }
        o.on('-i', '--interval SEC', Integer, 'rotation interval in seconds') { |v| opts[:interval] = v }
        o.on('-n', '--count N', Integer, 'number of rotations, 0 = infinite') { |v| opts[:count] = v }
        o.on('-k', '--kill-switch', 'block non-tor traffic while running') { opts[:kill_switch] = true }
        o.on('-q', '--quiet', 'suppress console logging') { opts[:quiet] = true }
        o.on('-y', '--yes', 'skip interactive prompts, use flags/defaults') { opts[:yes] = true }
        o.on('-h', '--help', 'show this help') { puts o; exit }
      end
      parser.parse!(argv)
      opts
    end
  end
end
