require 'helper'

class Page::Bus::TimetableTest < MiniTest::Unit::TestCase
  def test_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    assert_instance_of Mechanize::Page, Page::Bus::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').page
  end

  def test_route_pages
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    route_pages = Page::Bus::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').route_pages
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/3', route_pages.first.url.to_s
    assert_equal 'Oxenford, Helensvale, University, Hospital, Southport', route_pages.first.long_name
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/TX5', route_pages.last.url.to_s
    assert_equal 'Coomera stn, Dreamworld, Movieworld, Wet\'N Wild, H\'vale stn', route_pages.last.long_name
  end

  def test_route_pages_are_unique
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable/duplicate_routes.html'), :headers => {'Content-Type' => 'text/html'})
    timetable_page = Page::Bus::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables')
    route_pages    = timetable_page.route_pages
    assert_equal 440, route_pages.size
    assert_equal 1, route_pages.select { |route_page| route_page.url.to_s == 'http://jp.translink.com.au/travel-information/network-information/buses/LOOP/2012-09-24' }.size
  end

  def test_route_pages_omit_routes_before_route_with_url
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    url            = URI.parse 'http://jp.translink.com.au/travel-information/network-information/buses/10'
    timetable_page = Page::Bus::Timetable.new 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'
    route_pages    = timetable_page.route_pages url
    assert_equal 441, route_pages.size
    assert_equal url, route_pages.first.url
  end

  def test_route_pages_limited_by_step
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    url            = URI.parse 'http://jp.translink.com.au/travel-information/network-information/buses/10'
    timetable_page = Page::Bus::Timetable.new 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'
    route_pages    = timetable_page.route_pages url, 0
    assert_equal 1, route_pages.size
    assert_equal url, route_pages.first.url
  end

  def test_timetable_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:post, 'http://jp.translink.com.au/travel-information/network-information/timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    timetable_page = Page::Bus::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').timetable_page DateTime.parse('2012-06-04')
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/timetables', timetable_page.url.to_s
  end
end
