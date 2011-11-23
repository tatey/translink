module Translink
  class Crawler
    attr_accessor :model_class
    attr_reader   :url
    
    def initialize url
      @model_class = Model::Route
      @url         = URI.parse url
    end
    
    def crawl
      Page::Timetable.new(url.to_s).route_pages.each do |route_page|
        model_instance = model_class.find_or_add_from_route_page route_page
        model_instance.add_services_from_trip_pages *route_page.trip_pages
      end
    end
  end
end
