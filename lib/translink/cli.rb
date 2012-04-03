module Translink
  class CLI
    RUNNABLE = ['help', 'scrape']

    attr_accessor :out, :pwd, :__crawler__, :__stop__

    def initialize pwd
      self.__crawler__ = Translink::Crawler
      self.__stop__    = Model::Stop
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
      log 'Usage: translink scrape <DATE> [URI]'
      log ''
      log 'Examples:'
      log '    translink scrape 2011-11-24'
      log '    translink scrape 2011-11-24 sqlite://~/Desktop/2011-11-24.sqlite3'
    end

    def scrape input
      return help nil unless input =~ /^(\d{4}-\d{2}-\d{2})(\s+--uri="?(.+)"?)?$/
      date = Date.parse $1
      uri  = $3 || 'sqlite://' + File.join(pwd, "#{date}.sqlite3")
      DB.context uri, :migrate => true do
        crawler = __crawler__.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
        crawler.crawl date
      end
    end

    def log message
      out.puts message
    end
  end
end
