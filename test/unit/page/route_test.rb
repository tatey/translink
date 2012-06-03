require 'helper'

class Page::RouteTest < MiniTest::Unit::TestCase
  def test_date
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal DateTime.parse('1/06/2012 12:00:00 AM'), Page::Route.new('http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson').date
  end

  def test_long_name
    route = Page::Route.new('http://local', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson')
    assert_equal 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson', route.long_name
  end

  def test_short_name
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    assert_equal '130', Page::Route.new('http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson').short_name
  end

  def test_trip_pages
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04').
      to_return(:status => 200, :body => fixture('verbatim/route.html'), :headers => {'Content-Type' => 'text/html'})
    route = Page::Route.new('http://jp.translink.com.au/travel-information/network-information/buses/130/2012-06-04', 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson')
    trip_pages = route.trip_pages
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/outbound/8550/1712196/2012-05-31', trip_pages.first.url.to_s
    assert_equal route.date.to_date, trip_pages.first.date 
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/service-information/inbound/8552/1721391/2012-06-02', trip_pages.last.url.to_s
    assert_equal route.date.to_date, trip_pages.last.date 
  end
end
