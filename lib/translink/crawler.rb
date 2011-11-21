module Translink
  class Crawler
    attr_reader :url
    
    def initialize url
      @url = URI.parse url
    end
    
    def crawl
      route_pages.each do |route_page|
        route_model = route_model_from_route_page route_page
        route_page.trips.each do |trip_page|
          route_model.services << service_models_from_trip_page(trip_page)
        end
      end
    end

  protected
  
    def route_model_from_route_page route_page
      Model::Route.first_or_create :code => route_page.code,
                                   :name => route_page.name,
                                   :translink_id => translink_id
    end
    
    def route_pages
      Page::Timetable.new(url.to_s).routes
    end
    
    def service_models_from_trip_page trip_page
      trip_page.times.map { |time| Model::Service.new :time => time }
    end
  end
end
