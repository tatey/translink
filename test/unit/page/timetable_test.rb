require 'helper'

class Page::TimetableTest < MiniTest::Unit::TestCase
  def test_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    assert_instance_of Mechanize::Page, Page::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').page
  end

  def test_route_pages
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    route_pages = Page::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').route_pages
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/3', route_pages.first.url.to_s
    assert_equal 'Oxenford, Helensvale, University, Hospital, Southport', route_pages.first.long_name
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/TX5', route_pages.last.url.to_s
    assert_equal 'Coomera stn, Dreamworld, Movieworld, Wet\'N Wild, H\'vale stn', route_pages.last.long_name
  end

  def test_timetable_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:post, 'http://jp.translink.com.au/travel-information/network-information/timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    timetable_page = Page::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').timetable_page DateTime.parse('2012-06-04')
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/timetables', timetable_page.url.to_s
  end
end
