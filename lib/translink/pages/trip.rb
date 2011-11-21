module Translink
  module Pages
    class Trip
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end

      def stops
        table_rows.search('td:first-child').map { |td| td.text.strip }
      end
      
      def times
        table_rows.search('td:last-child').map { |td| td.text.strip }
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
      
    protected
    
      def table_rows
        @table_rows ||= page.search 'tbody tr'
      end
    end
  end
end
