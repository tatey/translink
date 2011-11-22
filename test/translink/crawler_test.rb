require 'helper'

class CrawlerTest < MiniTest::Unit::TestCase
  class Model
    attr_reader :services

    def initialize
      @services = []
    end

    def add_services services
      @services += services
    end

    def self.find_or_add route_page
      instance
    end
    
    def self.instance
      @instance ||= new
    end
  end
  
  def test_initialize  
    assert_equal 'http://localhost', Crawler.new('http://localhost').url.to_s
  end
  
  def test_crawl
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('small_timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/buses\/view-bus-timetable\/\d+\?direction=(In|Out)bound&routeCode=[0-9A-Z]+&timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('small_route.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/trip-details\/\d+\?timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('trip.html'), :headers => {'Content-Type' => 'text/html'})
    crawler = Crawler.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables'
    crawler.model_class = Model
    crawler.crawl
    assert_equal 150, Model.instance.services.size
    
    skip
    
    assert_equal '', Model.instance.services.first.time
    assert_equal '', Model.instance.services.last.time
  end
end
