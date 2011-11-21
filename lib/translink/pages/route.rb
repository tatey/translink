module Translink
  module Pages
    class Route
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def date
        Date.parse page.search('div#contentleftCol div.content p span').text
      end
            
      def direction
        page.search('div#contentleftCol div.content p').text.match(/(\S+)$/).captures.first
      end
      
      def name
        page.search('div#headingBar h1').text
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
      
      def trips
        anchors.map { |anchor| Trip.new anchor[:href] }
      end
      
    protected
    
      def anchors
        page.search 'table:not(:last-child) td a'
      end
    end
  end
end
