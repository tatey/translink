require 'helper'

class Model::RouteTest < MiniTest::Unit::TestCase
  def test_add_services_from_trip_pages
    DB.new('sqlite::memory:').use do
      time = DateTime.parse '2011-11-24 23:17:00'
      route_page = MiniTest::Mock.new
      route_page.expect :code, '130'
      route_page.expect :name, 'City Buz 130 Via Sunnybank'
      route_page.expect :translink_id, 1
      trip_page = MiniTest::Mock.new
      trip_page.expect :times, [time]
      route_model = Model::Route.find_or_add_from_route_page route_page
      route_model.add_services_from_trip_pages trip_page, trip_page, trip_page
      assert_equal 3, route_model.services.count
      assert route_model.services.all? { |service| service.time == time }, "Expected time to be #{time}."
      assert route_model.services.all? { |service| service.saved? }, 'Expected services to be saved.'
    end
  end
  
  def test_find_or_add_from_route_page
    DB.new('sqlite::memory:').use do
      route_page = MiniTest::Mock.new
      route_page.expect :code, '130'
      route_page.expect :name, 'City Buz 130 Via Sunnybank'
      route_page.expect :translink_id, 1
      Model::Route.find_or_add_from_route_page route_page
      Model::Route.find_or_add_from_route_page route_page
      assert_equal 1, Model::Route.count
      assert_equal Model::Route.find_or_add_from_route_page(route_page), Model::Route.find_or_add_from_route_page(route_page)
    end
  end
end
