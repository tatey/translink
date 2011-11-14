require 'helper'

class Pages::TimetableTest < MiniTest::Unit::TestCase
  def test_initialization_writes_attributes    
    assert_equal 'http://localhost', Pages::Timetables.new('http://localhost').url
  end
  
  def test_page_gets_url
    stub_request(:get, "http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables").
      to_return(:status => 200, :body => fixture('timetables.html'), :headers => {'Content-Type' => 'text/html'})          
    assert_instance_of Mechanize::Page, Pages::Timetables.new('http://jp.translink.com.au/travel-information/services-and-timetables/buses/bus-timetables').page
  end
end
