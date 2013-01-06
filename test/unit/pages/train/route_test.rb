require 'helper'

class Page::Train::RouteTest < MiniTest::Unit::TestCase
  def setup
    url = 'http://jp.translink.com.au/travel-information/network-information/trains/airport'
    stub_request(:get, url).
      to_return(:status => 200, :body => fixture('train/verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    @route = Page::Train::Route.new url, 'Airport'
  end

  def test_short_name
    assert_equal 'Airport', @route.short_name
  end

  def test_date
    assert_equal Date.parse('2013-01-07'), @route.date
  end

  def test_long_name
    assert_equal 'Roma Street, Varsity Lakes, Domestic Airport', @route.long_name
  end

  def test_route_id
    assert_equal 'airport', @route.route_id
  end

  def test_route_type
    assert_equal 2, @route.route_type
  end

  def test_trip_pages_has_every_trip
    assert_equal 86, @route.trip_pages.size
  end

  def test_trip_pages_first_trip_page
    trip_page = @route.trip_pages.first
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/upward/10581/2525614/2013-01-07', trip_page.url.to_s
    assert_equal @route.date, trip_page.date
    assert_equal Direction::GOOFY, trip_page.direction
  end

  def test_trip_pages_last_trip_page
    trip_page = @route.trip_pages.last
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/downward/10581/2525579/2013-01-07', trip_page.url.to_s
    assert_equal @route.date, trip_page.date
    assert_equal Direction::REGULAR, trip_page.direction
  end
end
