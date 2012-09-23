require 'helper'

class Model::RouteTest < MiniTest::Unit::TestCase
  def test_find_or_add_route_from_route_page
    DB.context 'sqlite::memory:', :migrate => true do
      route_page = MiniTest::Mock.new
      route_page.expect :short_name, '130'
      route_page.expect :long_name, 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson'
      route_page.expect :route_id, '130'
      route_page.expect :route_type, 0
      assert_equal 0, Model::Route.count
      assert_equal Model::Route.find_or_add_route_from_route_page(route_page), Model::Route.find_or_add_route_from_route_page(route_page)
      assert_equal 1, Model::Route.count
    end
  end

  def test_add_trip_from_trip_page
    DB.context 'sqlite::memory:', :migrate => true do
      trip_page   = OpenStruct.new :direction => Direction::REGULAR, :headsign => 'outbound', :trip_id => 1712196
      route_model = Model::Route.create :id => '130', :short_name => '130', :long_name => 'City, Griffith Uni, Sunnybank Hills, Algester, Parkinson', :route_type => 0
      trip_model  = route_model.add_trip_from_trip_page trip_page
      assert trip_model.saved?
    end
  end
end
