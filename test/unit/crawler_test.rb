require 'helper'

class CrawlerTest < MiniTest::Unit::TestCase
  def test_crawl
    DB.context 'sqlite::memory:', :migrate => true do
      stub_request(:get, 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables').
        to_return(:status => 200, :body => fixture('sample/timetable.html'), :headers => {'Content-Type' => 'text/html'})
      stub_request(:post, 'http://jp.translink.com.au/travel-information/network-information/timetables').
        to_return(:status => 200, :body => fixture('sample/timetable.html'), :headers => {'Content-Type' => 'text/html'})
      stub_request(:get, %r{http://jp.translink.com.au/travel-information/network-information/buses/\w+}).
        to_return(:status => 200, :body => fixture('sample/route.html'), :headers => {'Content-Type' => 'text/html'})
      stub_request(:get, %r{http://jp.translink.com.au/travel-information/network-information/service-information/\w+/\d+/\d+/\d+-\d+-\d+}).
        to_return(:status => 200, :body => fixture('verbatim/trip.html'), :headers => {'Content-Type' => 'text/html'})
      crawler = Crawler.new 'http://jp.translink.com.au/travel-information/services-and-timetables/buses/all-bus-timetables'
      crawler.crawl Date.today
      assert_equal 1, Model::Route.count
      assert_equal 1, Model::Trip.count
      assert_equal 27, Model::Stop.count
      assert_equal 27, Model::StopTime.count
    end
  end
end
