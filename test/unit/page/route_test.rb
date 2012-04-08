require 'helper'

class Page::RouteTest < MiniTest::Unit::TestCase
  def test_code
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal '130', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').code
  end
  
  def test_date
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal Date.parse('Monday 14 November 2011'), Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').date
  end
  
  def test_direction
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal 'inbound', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').direction
  end
  
  def test_name
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal 'City Buz 130 Via Sunnybank', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').name
  end
  
  def test_translink_id
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal '1925', Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').translink_id
  end
  
  def test_trip_pages
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    trip_pages = Page::Route.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1925?timetableDate=2011-11-14&direction=Inbound&routeCode=130').trip_pages
    assert_equal 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14', trip_pages.first.url.to_s
    assert_equal 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/252074?timetableDate=2011-11-14', trip_pages.last.url.to_s
  end
end
