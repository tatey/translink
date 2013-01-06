module Translink
  module Crawler
    class TripPage
      include Crawler::Try

      attr_reader :trip_page
      attr_reader :route_model

      def initialize trip_page, route_model
        @trip_page   = trip_page
        @route_model = route_model
      end

      def crawl out
        try out do
          trip_model = route_model.add_trip_from_trip_page trip_page
          trip_model.add_stop_times_from_stop_time_pages trip_page.stop_times
        end
      end
    end
  end
end
