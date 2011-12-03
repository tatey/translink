module Translink
  class CLI
    RUNNABLE = [:help, :import]
    
    attr_accessor :crawler_class, :out, :pwd
    
    def initialize pwd
      self.crawler_class = Translink::Crawler
      self.out           = $stdout
      self.pwd           = pwd
    end

    def run line
      command = line.slice! /^\S+/
      input   = line.strip
      if command && RUNNABLE.include?(command.to_sym)
        send command, input
      else
        help nil
      end
    end
    
  protected
        
    def help input
      log 'help'
    end
    
    def import input
      return help nil unless input =~ /^(\d{4}-\d{2}-\d{2})(\s+--uri="?(.+)"?)?$/
      date = Date.parse $1
      uri  = $3 || 'sqlite://' + File.join(pwd, "#{date}.sqlite3")
      DB.new uri do
        crawler_instance = crawler_class.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
        crawler_instance.crawl date
      end
    end
    
    def log message
      out.puts message
    end
  end
end
