require 'helper'

class Page::TripTest < MiniTest::Unit::TestCase
  def test_date
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal Date.parse('Monday 14 November 2011'), Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').date
  end
  
  def test_stops
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
    stops = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').stops    
    assert_equal Page::Trip::Stop.new('Illaweena St (Waterstone)', 'Waterstone, Illaweena St far side of Waterbrooke Crt'), stops.first
    assert_equal Page::Trip::Stop.new('Queen St Bus Station A6', 'Qsbs Stop A6'), stops.last
  end
  
  def test_times
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
    times = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').times
    assert_equal DateTime.parse('2011-11-14 05:00 +1000'), times.first
    assert_equal DateTime.parse('2011-11-14 05:50 +1000'), times.last
  end
  
  def test_trips
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
    trips = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').trips
    assert_equal Page::Trip::Stop.new('Illaweena St (Waterstone)', 'Waterstone, Illaweena St far side of Waterbrooke Crt'), trips.first.stop
    assert_equal DateTime.parse('2011-11-14 05:00 +1000'), trips.first.time
    assert_equal Page::Trip::Stop.new('Queen St Bus Station A6', 'Qsbs Stop A6'), trips.last.stop
    assert_equal DateTime.parse('2011-11-14 05:50 +1000'), trips.last.time
  end
end
