module Translink
  class CLI
    attr_reader :pwd
    
    def initialize pwd
      @pwd = pwd
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
      puts "Help: TODO"
    end
    
    def scrape input
      return help nil unless input =~ /^(\d{4}-\d{2}-\d{2})(\s+--uri="?(.+)"?)?$/
      date = $1
      path = $3 || 'sqlite://' + File.join(pwd, "#{date}.sqlite3")
      DataMapper.setup :default, "sqlite://#{path}"
      DataMapper.auto_migrate!
      Translink::Crawler.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables').crawl
    end
  end
end
