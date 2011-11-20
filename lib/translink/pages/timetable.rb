module Translink
  module Pages
    class Timetable
      attr_reader :page, :url
      
      def initialize url
        @url = url
      end
      
      def anchors
        page.search 'table tr td:first-child a'
      end
      
      def page
        @page ||= Mechanize.new.get url
      end
    end
  end
end
