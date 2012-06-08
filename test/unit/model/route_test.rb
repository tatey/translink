require 'helper'

class Model::RouteTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_route_page
    DB.context 'sqlite::memory:', :migrate => true do
      route_page = MiniTest::Mock.new
      route_page.expect :code, '130'
      route_page.expect :name, 'City Buz 130 Via Sunnybank'
      route_page.expect :direction, 'inbound'
      route_page.expect :translink_id, 1
      assert_equal Model::Route.find_or_add_from_route_page(route_page), Model::Route.find_or_add_from_route_page(route_page)
      assert_equal 1, Model::Route.count
    end
  end
end
