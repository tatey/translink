require 'helper'

class Pages::TimetableTest < MiniTest::Unit::TestCase
  def test_initialize 
    assert_equal 'http://localhost', Pages::Timetable.new('http://localhost').url
  end
  
  def test_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    assert_instance_of Mechanize::Page, Pages::Timetable.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').page
  end
  
  def test_routes
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    routes = Pages::Timetable.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').routes
    assert_equal '/travel-information/services-and-timetables/buses/view-bus-timetable/1953?timetableDate=2011-11-14&direction=Outbound&routeCode=10', routes.first.url
    assert_equal '/travel-information/services-and-timetables/buses/view-bus-timetable/2503?timetableDate=2011-11-14&direction=Inbound&routeCode=TX5', routes.last.url
  end
end
