require 'time'
require 'fileutils'

module GhostIp
  class Logger
    COLORS = {
      info:  "\e[1;36m",
      ok:    "\e[1;32m",
      warn:  "\e[1;33m",
      error: "\e[1;31m",
      dim:   "\e[1;30m",
      reset: "\e[0m"}.freeze
    def initialize(path, verbose: true)
      @path = path
      @verbose = verbose
      FileUtils.mkdir_p(File.dirname(@path)) rescue nil
    end
    def info(msg)  ; emit(:info, msg)  ; end
    def ok(msg)    ; emit(:ok, msg)    ; end
    def warn(msg)  ; emit(:warn, msg)  ; end
    def error(msg) ; emit(:error, msg) ; end
    def raw(msg)
      puts msg
      persist(msg)
    end
    private

    def emit(level, msg)
      stamp = Time.now.strftime('%H:%M:%S')
      color = COLORS[level]
      tag = level.to_s.upcase
      line = "\e[1;33m[#{stamp}]#{COLORS[:reset]} #{color}#{tag}#{COLORS[:reset]} #{msg}"
      puts line if @verbose
      persist("[#{stamp}] #{tag} #{msg}")
    end

    def persist(line)
      File.open(@path, 'a') { |f| f.puts(line) }
    rescue StandardError
      nil
    end
  end
end
