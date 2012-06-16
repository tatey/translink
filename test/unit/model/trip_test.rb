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

  def test_add_stop_time_from_stop_time_page
    stop_time_page  = OpenStruct.new :arrival_time => '10:00 A.M.', :stop_page => OpenStruct.new, :stop_sequence => 7
    trip_model      = Model::Trip.new
    stop_time_model = trip_model.add_stop_time_from_stop_time_page stop_time_page
    assert_equal stop_time_model.arrival_time, stop_time_page.arrival_time
    assert_equal stop_time_model.stop_sequence, stop_time_page.stop_sequence
  end
end
