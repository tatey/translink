require 'helper'

class Page::RouteTest < MiniTest::Unit::TestCase
  attr_accessor :route

  def setup
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/130/2012-09-24').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    @route = Page::Route.new 'http://jp.translink.com.au/travel-information/network-information/buses/130/2012-09-24', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson'
  end

  def test_date
    assert_equal DateTime.parse('24/09/2012 12:00:00 AM'), route.date
  end

  def test_direction_from_anchor
    anchor = route.page.search('a.map-link-top').first
    assert_equal Direction::REGULAR, route.direction_from_anchor(anchor)
  end

  def test_headsigns
    assert_equal ['outbound', 'inbound'], route.headsigns
  end

  def test_route_id
    assert_equal '130', route.route_id
  end

  def test_short_name
    assert_equal '130', route.short_name
  end

  def test_trip_pages
    trip_pages = route.trip_pages
    trip1 = trip_pages.first
    trip2 = trip_pages.last
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/outbound/9792/2170894/2012-09-24', trip1.url.to_s
    assert_equal route.date.to_date, trip1.date
    assert_equal Direction::REGULAR, trip1.direction
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/inbound/9792/2180194/2012-09-24', trip2.url.to_s
    assert_equal route.date.to_date, trip2.date
    assert_equal Direction::GOOFY, trip2.direction
  end
end

class Page::RouteLongNameTest < MiniTest::Unit::TestCase
  def test_long_name
    route = Page::Route.new('http://local', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson')
    assert_equal 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson', route.long_name
  end
end

class Page::RouteTypeTest < MiniTest::Unit::TestCase
  def test_bus
    assert_equal 3, Page::Route.new('http://jp.translink.com.au/travel-information/network-information/buses/all-timetables', 'City').route_type
  end

  def test_ferry
    assert_equal 4, Page::Route.new('http://jp.translink.com.au/travel-information/network-information/ferries/all-timetables', 'City').route_type 
  end

  def test_train
    assert_equal 0, Page::Route.new('http://jp.translink.com.au/travel-information/network-information/trains/richlands', 'City').route_type
  end

  def test_exception
    assert_raises Page::Route::UnknownRouteTypeError do
      Page::Route.new('http://foo', 'City').route_type
    end
  end
end

class Page::DateFromAnchorTest < MiniTest::Unit::TestCase
  attr_accessor :route

  def setup
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/120/2012-09-24').
      to_return(:status => 200, :body => fixture('verbatim/route/date_from_anchor.html'), :headers => {'Content-Type' => 'text/html'})
    @route = Page::Route.new 'http://jp.translink.com.au/travel-information/network-information/buses/120/2012-09-24', 'City, SthBank, Buranda, Salisbury, Griffith Uni, Garden City'
  end

  def test_unparsable_date
    anchor = route.page.search('a.map-link-top')[0]
    assert_equal DateTime.parse('01/01/1970 12:00:00 AM'), route.date_from_anchor(anchor)
    anchor = route.page.search('a.map-link-top')[1]
    assert_equal DateTime.parse('01/01/1970 12:00:00 AM'), route.date_from_anchor(anchor)
  end

  def test_parsable_date
    anchor = route.page.search('a.map-link-top')[2]
    assert_equal DateTime.parse('24/09/2012 12:00:00 AM'), route.date_from_anchor(anchor)
  end
end
