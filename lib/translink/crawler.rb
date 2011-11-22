module Translink
  class Crawler
    attr_reader :url
    
    def initialize url
      @url = URI.parse url
    end
    
    def crawl
      Page::Timetable.new(url.to_s).route_pages.each do |route_page|
        route_model = route_model_class.find_or_add route_page
        route_model.add_services route_page.service_models
      end
    end
    
  protected
    
    def route_model_class
      @route_model_class ||= Model::Route
    end
  end
end
