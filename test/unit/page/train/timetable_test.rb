require 'helper'

class Page::Train::TimetableTest < MiniTest::Unit::TestCase
  def setup
    stub_request(:get, 'http://jp.translink.com.au/travel-information/network-information/trains/all-timetables').
      to_return(:status => 200, :body => fixture('train/verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    @timetable = Page::Train::Timetable.new 'http://jp.translink.com.au/travel-information/network-information/trains/all-timetables'
  end

  def test_route_pages_has_every_route
    assert_equal 11, @timetable.route_pages.size
  end

  def test_route_pages_first_page
    route_page = @timetable.route_pages.first
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/trains/airport', route_page.url.to_s
    assert_equal 'Airport', route_page.long_name
  end

  def test_route_pages_last_page
    route_page = @timetable.route_pages.last
    assert_equal 'http://jp.translink.com.au/travel-information/network-information/trains/doomben', route_page.url.to_s
    assert_equal 'Doomben', route_page.long_name
  end
end
