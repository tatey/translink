module Translink
  class CLI
    RUNNABLE = ['extract', 'help', 'import']

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

    def extract input
      return help nil unless input =~ /[A-Za-z]:\/\/.+/
      DB.new input do
        __stop__.all.each do |stop|
          stop.extract!
          stop.save!
        end
      end
    end

    def help input
      log 'help'
    end

    def import input
      return help nil unless input =~ /^(\d{4}-\d{2}-\d{2})(\s+--uri="?(.+)"?)?$/
      date = Date.parse $1
      uri  = $3 || 'sqlite://' + File.join(pwd, "#{date}.sqlite3")
      DB.new uri do
        crawler = __crawler__.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
        crawler.crawl date
      end
    end

    def log message
      out.puts message
    end
  end
end
