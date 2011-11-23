module Translink
  module Page
    class Trip
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def date
        Date.parse page.search('div#contentleftCol p span').text
      end

      def stops
        table_rows.search('td:first-child').map { |td| td.text.strip }
      end
      
      def times
        table_rows.search('td:last-child').map { |td| date_time(td.text.strip) }
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
