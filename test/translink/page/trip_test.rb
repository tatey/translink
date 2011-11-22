require 'helper'

class Page::TripTest < MiniTest::Unit::TestCase
  def test_initialize    
    assert_equal 'http://localhost', Page::Trip.new('http://localhost').url.to_s
  end
  
  def test_service_models
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('trip.html'), :headers => {'Content-Type' => 'text/html'})
    service_models = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').service_models
    assert_equal 25, service_models.size
    skip 'Test first and last match the expected times. Use a datetime object.'
  end
  
  def test_stops
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('trip.html'), :headers => {'Content-Type' => 'text/html'})
    times = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').times
    assert_equal '5.00am', times.first
    assert_equal '5.50am', times.last
  end
  
  def test_times
    stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').
      to_return(:status => 200, :body => fixture('trip.html'), :headers => {'Content-Type' => 'text/html'})
    stops = Page::Trip.new('http://jp.translink.com.au/travel-information/services-and-timetables/trip-details/281889?timetableDate=2011-11-14').stops
    assert_equal "Illaweena St (Waterstone)\nWaterstone, Illaweena St far side of Waterbrooke Crt", stops.first
    assert_equal "Queen St Bus Station A6\nQsbs Stop A6", stops.last
  end
end
