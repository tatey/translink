require 'helper'

class Page::TimetableTest < MiniTest::Unit::TestCase
  def test_initialize 
    assert_equal 'http://localhost', Page::Timetable.new('http://localhost').url.to_s
  end
  
  def test_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    assert_instance_of Mechanize::Page, Page::Timetable.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').page
  end
  
  def test_route_pages
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})          
    route_pages = Page::Timetable.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').route_pages
    assert_equal 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/1953?timetableDate=2011-11-14&direction=Outbound&routeCode=10', route_pages.first.url.to_s
    assert_equal 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/view-bus-timetable/2503?timetableDate=2011-11-14&direction=Inbound&routeCode=TX5', route_pages.last.url.to_s
  end
end
