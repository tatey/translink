module Translink
  class Crawler
    attr_accessor :__model__
    attr_reader   :url

    def initialize url
      @__model__ = Model::Route
      @url       = URI.parse url
    end

    def crawl date
      timetable_page = Page::Timetable.new(url.to_s).timetable_page date
      timetable_page.route_pages.each do |route_page|
        model = __model__.find_or_add_from_route_page route_page
        route_page.trip_pages.each do |trip_page|
          model.add_service_from_trip_page trip_page
        end
      end
    end
  end
end
