module Translink
  module Page
    class Timetable
      attr_reader :page, :url
      
      def initialize url
        @url = URI.parse url
      end
      
      def page
        @page ||= Mechanize.new.get url.to_s
      end
      
      def routes
        anchors.map { |anchor| Route.new absolute_url(anchor['href']) }
      end
      
    protected
    
      def absolute_url path
        url.scheme + '://' + url.host + path
      end
    
      def anchors
        page.search 'table tr td:first-child a'
      end      
    end
  end
end
