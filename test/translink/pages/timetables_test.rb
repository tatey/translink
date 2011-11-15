require 'helper'

class Pages::TimetableTest < MiniTest::Unit::TestCase
  def test_initialization_writes_attributes    
    assert_equal 'http://localhost', Pages::Timetables.new('http://localhost').url
  end
  
  def test_page_gets_url
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetables.html'), :headers => {'Content-Type' => 'text/html'})          
    assert_instance_of Mechanize::Page, Pages::Timetables.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').page
  end
  
  def test_anchors_searces_for_routes
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').
      to_return(:status => 200, :body => fixture('timetables.html'), :headers => {'Content-Type' => 'text/html'})          
    anchors = Pages::Timetables.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').anchors
    assert_equal '/travel-information/services-and-timetables/buses/view-bus-timetable/1953?timetableDate=2011-11-14&direction=Outbound&routeCode=10', anchors[0][:href]
    assert_equal '10 - Outbound', anchors[0].text
    assert_equal '/travel-information/services-and-timetables/buses/view-bus-timetable/1953?timetableDate=2011-11-14&direction=Inbound&routeCode=10', anchors[1][:href]
    assert_equal '10 - Inbound', anchors[1].text
  end
end
