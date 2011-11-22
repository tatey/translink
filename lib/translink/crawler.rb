module Translink
  class Crawler
    attr_accessor :model_class
    attr_reader   :url
    
    def initialize url
      @model_class = Model::Route
      @url         = URI.parse url
    end
    
    def crawl
      route_pages.each do |route_page|
        model_instance = model_class.find_or_add route_page
        model_instance.add_services route_page.service_models
      end
    end
    
  protected
  
    def route_pages
      Page::Timetable.new(url.to_s).route_pages
    end
  end
end
