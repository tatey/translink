require 'helper'

class CrawlerTest < MiniTest::Unit::TestCase
  def test_initialize  
    assert_equal 'http://localhost', Crawler.new('http://localhost').url.to_s
  end
  
  def test_crawl
    skip 'This test is way too slow.'
    
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/buses\/view-bus-timetable\/\d+\?direction=(In|Out)bound&routeCode=[0-9A-Z]+&timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:get, /http:\/\/jp.translink.com.au\/travel-information\/services-and-timetables\/trip-details\/\d+\?timetableDate=\d{4}-\d{2}-\d{2}/).
      to_return(:status => 200, :body => fixture('trip.html'), :headers => {'Content-Type' => 'text/html'})
    
    service_models = []
    route_model_instance = MiniTest::Mock.new
    route_model_instance.expect :add_services, true, [Array]
    route_model_instance.expect :services, service_models
    route_model_class = MiniTest::Mock.new
    route_model_class.expect :find_or_add, route_model_instance, [Page::Route]
    
    crawler = Crawler.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables'
    crawler.instance_variable_set '@route_model_class', route_model_class
    crawler.crawl
    
    assert_equal 20, service_models.size
    skip 'Test first and last match the expected times. Use a datetime object.'
  end
end
