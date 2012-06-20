module Translink
  class Crawler
    attr_reader :url

    def initialize url
      @url = URI.parse url
    end

    def crawl date
      timetable_page = Page::Timetable.new(url.to_s).timetable_page date
      timetable_page.route_pages.each do |route_page|
        route_model = Model::Route.find_or_add_route_from_route_page route_page
        route_page.trip_pages.each do |trip_page|
          trip_model = route_model.add_trip_from_trip_page trip_page
          trip_model.add_stop_times_from_stop_time_pages trip_page.stop_times
        end
      end
    end
  end
end
