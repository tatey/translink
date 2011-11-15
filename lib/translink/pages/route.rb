module Translink
  module Pages
    class Route
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def anchors
        page.search 'table:not(:last-child) td a'
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
    end
  end
end
