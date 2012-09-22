require 'helper'

class Page::TripTest < MiniTest::Unit::TestCase
  def test_date
    timestamp = DateTime.now
    assert_equal timestamp.to_date, Page::Trip.new('http://localhost', timestamp, Direction::REGULAR).date
    date = Date.today
    assert_equal date, Page::Trip.new('http://localhost', date, Direction::REGULAR).date
  end

  def test_direction
    timestamp = DateTime.now
    assert_equal Direction::REGULAR, Page::Trip.new('http://localhost', timestamp, Direction::REGULAR).direction
    assert_equal Direction::GOOFY, Page::Trip.new('http://localhost', timestamp, Direction::GOOFY).direction
  end

  def test_headsign
    assert_equal 'inbound', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/inbound/8550/1704728', Date.today, Direction::GOOFY).headsign
    assert_equal 'outbound', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31', Date.today, Direction::REGULAR).headsign
    assert_equal 'counterclockwise', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/counterclockwise/8904/1882248/2012-06-25', Date.today, Direction::GOOFY).headsign
    assert_equal 'clockwise', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/clockwise/8904/1882152/2012-06-25', Date.today, Direction::REGULAR).headsign
  end
end

class Page::TripRequestTest < MiniTest::Unit::TestCase
  def setup
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
  end

  def stub_trip
    Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31', Date.today, Direction::REGULAR)
  end

  def test_stop_times
    stop_page1 = Page::Trip::Stop.new.tap { |s| s.stop_name = 'Queen Street station, platform A6'; s.stop_id = '001002'; s.stop_lat = '-27.470677'; s.stop_lon = '153.024747' }
    stop_page2 = Page::Trip::Stop.new.tap { |s| s.stop_name = 'Illaweena St at Waterstone'; s.stop_id = '010764'; s.stop_lat = '-27.639463'; s.stop_lon = '153.052551' }
    stop_times = stub_trip.stop_times
    stop_time1 = stop_times.first
    stop_time2 = stop_times.last
    assert_equal 27, stop_times.size
    assert_equal 0, stop_time1.stop_sequence
    assert_equal '11:25 P.M.', stop_time1.arrival_time
    assert_equal stop_page1, stop_time1.stop_page
    assert_equal 26, stop_time2.stop_sequence
    assert_equal '12:14 A.M.', stop_time2.arrival_time
    assert_equal stop_page2, stop_time2.stop_page
  end

  def test_trip_id
    assert_equal '1712196', stub_trip.trip_id
  end
end
