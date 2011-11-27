module Translink
  class CLI
    attr_accessor :crawler_class, :logger, :pwd
    
    def initialize pwd
      self.crawler_class = Translink::Crawler
      self.logger        = Logger.new($stdout).tap { |logger| logger.level = Logger::INFO }
      self.pwd           = pwd
    end

    def run line
      command = line.slice! /^\S+/
      input   = line.strip
      if command && respond_to?(command)
        send command, input
      else
        help nil
      end
    end
    
  protected
        
    def help input
      logger.info 'help'
    end
    
    def import input
      return help nil unless input =~ /^(\d{4}-\d{2}-\d{2})(\s+--uri="?(.+)"?)?$/
      date = $1
      uri  = $3 || 'sqlite://' + File.join(pwd, "#{date}.sqlite3")
      DB.new(uri).use do
        crawler_instance = crawler_class.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
        crawler_instance.crawl
      end
    end
  end
end
