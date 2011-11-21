require 'helper'

class Page::RouteTest < MiniTest::Unit::TestCase
  def test_initialize    
    assert_equal 'http://localhost', Page::Route.new('http://localhost').url
  end
  
  def test_code
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal '130', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').code
  end
  
  def test_date
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal Date.parse('Monday 14 November 2011'), Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').date
  end
  
  def test_direction
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal 'Inbound', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').direction
  end
  
  def test_name
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal 'City Buz 130 Via Sunnybank', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').name
  end
  
  def test_trips
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('route.html'), :headers => {'Content-Type' => 'text/html'})
    trips = Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').trips
    assert_equal '/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14', trips.first.url
    assert_equal '/travel-information/services-and-timetables/trip-details/252074?timetableDate=2011-11-14', trips.last.url
  end
end
