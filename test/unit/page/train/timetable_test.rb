require 'helper'

class Page::Train::TimetableClassTest < MiniTest::Unit::TestCase
  def test_timetable_page_returns_new_instance
    url  = 'http://local'
    date = Date.today
    timetable = Page::Train::Timetable.timetable_page url, date
    assert_equal url, timetable.url.to_s
    assert_equal date, timetable.date
  end
end

class Page::Train::TimetableInstanceTest < MiniTest::Unit::TestCase
  def setup
    url = 'http://jp.translink.com.au/travel-information/network-information/trains/all-timetables'
    stub_request(:get, url).
      to_return(:status => 200, :body => fixture('train/verbatim/timetable.html'), :headers => {'Content-Type' => 'text/html'})
    @timetable = Page::Train::Timetable.new url, Date.today
  end

  def test_route_pages_has_every_route
    assert_equal 11, @timetable.route_pages.size
  end

  def test_route_pages_first_route_page
    route_page = @timetable.route_pages.first
    assert_equal "http://jp.translink.com.au/travel-information/network-information/trains/airport/#{@timetable.date}", route_page.url.to_s
    assert_equal 'Airport', route_page.short_name
  end

  def test_route_pages_last_route_page
    route_page = @timetable.route_pages.last
    assert_equal "http://jp.translink.com.au/travel-information/network-information/trains/doomben/#{@timetable.date}", route_page.url.to_s
    assert_equal 'Doomben', route_page.short_name
  end
end
