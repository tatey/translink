module Translink
  module Page
    class Trip
      Service = Struct.new :stop, :time
      Stop    = Struct.new :name, :locality
      
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def date
        Date.parse page.search('div#contentleftCol p span').text
      end
      
      def services
        stops.zip(times).map { |attributes| Service.new *attributes }
      end

      def stops
        table_rows.search('td:first-child').map do |td| 
          attributes = td.text.strip.split "\n"
          Stop.new *attributes
        end
      end
      
      def times
        table_rows.search('td:last-child').map { |td| date_time td.text.strip }
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
      
    protected
    
      def date_time time_string
        DateTime.parse "#{date} #{time_string.sub('.', ':')} +1000"
      end
    
      def table_rows
        @table_rows ||= page.search 'tbody tr'
      end
    end
  end
end
