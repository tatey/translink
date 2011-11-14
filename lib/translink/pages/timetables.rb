module Translink
  module Pages
    class Timetables
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def anchors
        page.search 'table tr td:first-child a'
      end
      
      def routes
        anchors.each { |anchor| Route.new anchor[:href] }
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
    end
  end
end
