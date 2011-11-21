require 'helper'

class CrawlerTest < MiniTest::Unit::TestCase
  def test_initialize  
    assert_equal 'http://localhost', Crawler.new('http://localhost').url.to_s
  end
  
  def test_crawl
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    Crawler.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').crawl
    assert_equal 10, Model::Route.count
    assert_equal 90, Model::Service.count
  end
end
