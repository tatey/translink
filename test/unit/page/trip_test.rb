require 'helper'

class Page::TripTest < MiniTest::Unit::TestCase
  def test_date
    timestamp = DateTime.now
    assert_equal timestamp.to_date, Page::Trip.new('http://localhost', timestamp).date
    date = Date.today
    assert_equal date, Page::Trip.new('http://localhost', date).date
  end

  def test_direction
    assert_equal 'inbound', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/inbound/8550/1704728', Date.today).direction
    assert_equal 'outbound', Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31', Date.today).direction
  end
end

class Page::TripRequestTest < MiniTest::Unit::TestCase
  def setup
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
  end

  def stub_trip
    Page::Trip.new('http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31', Date.today)
  end

  def test_service_id
    assert_equal '1712196', stub_trip.service_id
  end

  def test_stop_times
    stop1      = Page::Trip::Stop.new.tap { |s| s.stop_name = 'Queen Street station, platform A6'; s.stop_id = '001002' }
    stop2      = Page::Trip::Stop.new.tap { |s| s.stop_name = 'Illaweena St at Waterstone'; s.stop_id = '010764' }
    stop_times = stub_trip.stop_times
    stop_time1 = stop_times.first
    stop_time2 = stop_times.last
    assert_equal 27, stop_times.size
    assert_equal 0, stop_time1.stop_sequence
    assert_equal '11:25 P.M.', stop_time1.arrival_time
    assert_equal stop1, stop_time1.stop
    assert_equal 26, stop_time2.stop_sequence
    assert_equal '12:14 A.M.', stop_time2.arrival_time
    assert_equal stop2, stop_time2.stop
  end

  def test_trip_id
    assert_equal '8550', stub_trip.trip_id
  end
end
