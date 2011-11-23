module Translink
  module Page
    class Route
      attr_reader :page, :url
      
      def initialize url
        @url = URI.parse url
      end
      
      def code
        page.search('div#contentleftCol table th:nth-child(2)').first.text.strip
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
      
      def trip_pages
        anchors.map { |anchor| Trip.new absolute_url(anchor[:href]) }
      end
      
    protected
    
      def absolute_url path
        url.scheme + '://' + url.host + path
      end
    
      def anchors
        page.search 'table:not(:last-child) tfoot a'
      end
    end
  end
end
