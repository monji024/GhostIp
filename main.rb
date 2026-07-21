#!/usr/bin/env ruby
$stdout.sync = true

require_relative 'lib/config'
require_relative 'lib/logger'
require_relative 'lib/tor_controller'
require_relative 'lib/ip_lookup'
require_relative 'lib/stats'
require_relative 'lib/kill_switch'
require_relative 'lib/ui'
require_relative 'lib/cli'
require_relative 'lib/engine'

opts = GhostIp::Cli.parse(ARGV)
config = GhostIp::Config.load(opts[:config] || 'config.yml')
config['interval'] = opts[:interval] if opts[:interval]
config['count'] = opts[:count] if opts[:count]
config['kill_switch'] = true if opts[:kill_switch]

GhostIp::Engine.new(config, opts).run
