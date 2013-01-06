module Translink
  module Crawler
    class TimetablePage
      include Crawler::Try

      attr_reader :timetable_page

      def initialize timetable_page
        @timetable_page = timetable_page
      end

      def crawl out
        try out do
          timetable_page.route_pages.each do |route_page|
            Crawler::RoutePage.new(route_page).crawl out
          end
        end
      end
    end
  end
end
