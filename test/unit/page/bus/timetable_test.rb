require 'helper'

class Page::Bus::TimetableConstructorTest < MiniTest::Unit::TestCase
  def test_timetable_page_returns_new_instance
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:post, 'http://jp.translink.com.au/travel-information/network-information/timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    timetable = Page::Bus::Timetable.timetable_page 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables', Date.parse('2012-06-04')
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/timetables', timetable.url.to_s
  end
end

class Page::Bus::TimetableTimetablePageTest < MiniTest::Unit::TestCase
  def test_timetable_page
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    stub_request(:post, 'http://jp.translink.com.au/travel-information/network-information/timetables').
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    timetable_page = Page::Bus::Timetable.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables').timetable_page DateTime.parse('2012-06-04')
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/timetables', timetable_page.url.to_s
  end
end

class Page::Bus::TimetableRoutePagesTest < MiniTest::Unit::TestCase
  def setup
    url = 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'
    stub_request(:get, url).
      to_return(:status => 200, :body => fixture('verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    @timetable = Page::Bus::Timetable.new url
  end

  def test_route_pages_has_every_route
    assert_equal 444, @timetable.route_pages.size
  end

  def test_route_pages_first_route_page
    route_page = @timetable.route_pages.first
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/3', route_page.url.to_s
    assert_equal 'Oxenford, Helensvale, University, Hospital, Southport', route_page.long_name
  end

  def test_route_pages_last_route_page
    route_page = @timetable.route_pages.last
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/buses/TX5', route_page.url.to_s
    assert_equal 'Coomera stn, Dreamworld, Movieworld, Wet\'N Wild, H\'vale stn', route_page.long_name
  end
end

class Page::Bus::TimetableRoutePagesUniqueTest < MiniTest::Unit::TestCase
  def setup
    url = 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'
    stub_request(:get, url).
      to_return(:status => 200, :body => fixture('verbatim/timetable/duplicate_routes.html'), :headers => {'Content-Type' => 'text/html'})
    @timetable = Page::Bus::Timetable.new url
  end

  def test_routes_is_unique_routes
    assert_equal 440, @timetable.route_pages.size
  end

  def test_route_pages_excludes_duplicates
    assert_equal 1, @timetable.route_pages.select { |route_page| route_page.url.to_s == 'http://jp.translink.com.au/travel-information/network-information/buses/LOOP/2012-09-24' }.size
  end
end
