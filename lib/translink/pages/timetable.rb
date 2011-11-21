module Translink
  module Pages
    class Timetable
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
      
      def routes
        anchors.map { |anchor| Route.new anchor['href'] }
      end
      
    protected
    
      def anchors
        page.search 'table tr td:first-child a'
      end
    end
  end
end
