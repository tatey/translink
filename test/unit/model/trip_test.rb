require 'helper'

class Model::TripTest < MiniTest::Unit::TestCase
  def test_trip_page_with_bang
    trip_page  = OpenStruct.new :direction => 'outbound', :service_id => 8550, :trip_id => 1712196
    trip_model = Model::Trip.new
    trip_model.trip_page! trip_page
    assert_equal trip_model.direction, trip_page.direction
    assert_equal trip_model.service_id, trip_page.service_id
    assert_equal trip_model.trip_id, trip_page.trip_id
  end
end
