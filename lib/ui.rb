module GhostIp
  class UI
    BANNER = <<~ART
      \e[1;32;40m
       ██████╗ ██╗  ██╗ ██████╗ ███████╗████████╗██╗██████╗
      ██╔════╝ ██║  ██║██╔═══██╗██╔════╝╚══██╔══╝██║██╔══██╗
      ██║  ███╗███████║██║   ██║███████╗   ██║   ██║██████╔╝
      ██║   ██║██╔══██║██║   ██║╚════██║   ██║   ██║██╔═══╝
      ╚██████╔╝██║  ██║╚██████╔╝███████║   ██║   ██║██║
       ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ ╚══════╝   ╚═╝   ╚═╝╚═╝
      \e[0m
    ART

    def self.clear
      system('clear') || system('cls')
    end

    def self.banner(version)
      clear
      puts BANNER
      puts "\e[1;33mv#{version} :: tor identity rotator\e[0m\n\n"
    end

    def self.status_line(label, value, color = "\e[1;32m")
      puts " #{label.ljust(18)} #{color}#{value}\e[0m"
    end

    def self.divider
      puts "\e[1;30m" + ("─" * 54) + "\e[0m"
    end

    def self.prompt(text, default)
      print "\e[1;36m ? #{text} [#{default}]: \e[0m"
      answer = $stdin.gets.to_s.chomp
      answer.empty? ? default : answer
    end

    def self.progress(current, total)
      pct = total.zero? ? 0 : ((current.to_f / total) * 100).round
      puts "\e[1;33m progress #{current}/#{total} (#{pct}%)\e[0m"
    end
  end
end
