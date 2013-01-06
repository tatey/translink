module Translink
  module Crawler
    class RoutePage
      include Crawler::Try

      attr_reader :route_page

      def initialize route_page
        @route_page = route_page
      end

      def crawl out
        try out do
          route_model = Model::Route.find_or_add_route_from_route_page route_page
          route_page.trip_pages.each do |trip_page|
            Crawler::TripPage.new(trip_page, route_model).crawl out
          end
        end
      end
    end
  end
end
