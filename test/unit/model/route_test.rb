require 'helper'

class Model::RouteTest < MiniTest::Unit::TestCase
  def test_add_services_from_trip_pages
    DB.context 'sqlite::memory:', :migrate => true do
      trip = Page::Trip::Trip.new.tap do |t|
        t.stop = Page::Trip::Stop.new 'Illaweena St (Waterstone)', 'Waterstone, Illaweena St far side of Waterbrooke Crt'
        t.time = DateTime.parse '2011-11-24 23:17:00'
      end
      route_page = MiniTest::Mock.new
      route_page.expect :code, '130'
      route_page.expect :name, 'City Buz 130 Via Sunnybank'
      route_page.expect :translink_id, 1
      trip_page = MiniTest::Mock.new
      trip_page.expect :trips, [trip]
      route_model = Model::Route.find_or_add_from_route_page route_page
      route_model.add_service_from_trip_page trip_page
      route_model.add_service_from_trip_page trip_page
      route_model.add_service_from_trip_page trip_page
      assert_equal 3, Model::Service.count
      assert_equal 1, Model::Stop.count
    end
  end

  def test_find_or_add_from_route_page
    DB.context 'sqlite::memory:', :migrate => true do
      route_page = MiniTest::Mock.new
      route_page.expect :code, '130'
      route_page.expect :name, 'City Buz 130 Via Sunnybank'
      route_page.expect :translink_id, 1
      assert_equal Model::Route.find_or_add_from_route_page(route_page), Model::Route.find_or_add_from_route_page(route_page)
      assert_equal 1, Model::Route.count
    end
  end
end
