module Translink
  class CLI
    RUNNABLE = ['help', 'scrape', 'version']
    URL      = 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'

    attr_accessor :out, :pwd, :__crawler__

    def initialize pwd
      self.__crawler__ = Translink::Crawler
      self.out         = $stdout
      self.pwd         = pwd
    end

    def run line
      command, input = line.split /\s/, 2
      if RUNNABLE.include? command
        send command, input
      else
        help nil
      end
    end

  protected

    def help input
      tomorrow = Date.today + 1
      log 'Usage: translink scrape <DATE> [DB_PATH] [FROM_ROUTE_URL] [STEP]'
      log '       translink version'
      log ''
      log 'Examples:'
      log "    translink scrape #{tomorrow}"
      log "    translink scrape #{tomorrow} ~/Desktop/#{tomorrow}.sqlite3"
      log "    translink scrape #{tomorrow} ~/Desktop/#{tomorrow}.sqlite3 http://jp.translink.com.au/travel-information/network-information/buses/435"
      log "    translink scrape #{tomorrow} ~/Desktop/#{tomorrow}.sqlite3 http://jp.translink.com.au/travel-information/network-information/buses/435/#{tomorrow} 0"
    end

    def scrape input
      args = (input || '').split /\s/
      case args.size
      when 1
        date    = Date.parse args[0]
        db_path = File.join(pwd, "#{date}.sqlite3")
      when 2
        date    = Date.parse args[0]
        db_path = File.expand_path args[1]
      when 3
        date           = Date.parse args[0]
        db_path        = File.expand_path args[1]
        from_route_url = URI.parse args[2]
      when 4
        date           = Date.parse args[0]
        db_path        = File.expand_path args[1]
        from_route_url = URI.parse args[2]
        step           = args[3].to_i
      else
        help nil
        return
      end
      DB.context "sqlite://#{db_path}", :migrate => !File.exists?(db_path) do
        crawler = __crawler__.new URL
        crawler.crawl date, from_route_url, step
      end
    end

    def version input
      log VERSION
    end

    def log message
      out.puts message
    end
  end
end
