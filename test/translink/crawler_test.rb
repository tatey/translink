require 'helper'

class CrawlerTest < MiniTest::Unit::TestCase
  class Model
    attr_reader :trip_pages

    def initialize
      @trip_pages = []
    end

    def add_services_from_trip_pages *trip_pages
      @trip_pages += trip_pages
    end

    def self.find_or_add_from_route_page route_page
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
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables').
      to_return(:status => 200, :body => fixture('sample/timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/buses\/view-bus-timetable\/\d+\?direction=(In|Out)bound&routeCode=[0-9A-Z]+&timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('sample/route.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/trip-details\/\d+\?timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
    crawler = Crawler.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
    crawler.model_class = Model
    crawler.crawl
    assert_equal 6, Model.instance.trip_pages.size
    assert Model.instance.trip_pages.all? { |trip_page| trip_page.is_a? Page::Trip }
  end
end
