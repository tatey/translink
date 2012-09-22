require 'helper'

class Model::TripTest < MiniTest::Unit::TestCase
  def test_trip_page_with_bang
    trip_page  = OpenStruct.new :direction => Direction::REGULAR, :headsign => 'outbound', :trip_id => 1712196
    trip_model = Model::Trip.new
    trip_model.trip_page! trip_page
    assert_equal trip_model.direction, trip_page.direction
    assert_equal trip_model.headsign, trip_page.headsign
    assert_equal trip_model.id, trip_page.trip_id
  end

  def test_add_stop_time_from_stop_time_page
    stop_time_page  = OpenStruct.new :arrival_time => '10:00 A.M.', :stop_page => OpenStruct.new, :stop_sequence => 7
    trip_model      = Model::Trip.new
    stop_time_model = trip_model.add_stop_time_from_stop_time_page stop_time_page
    assert_equal stop_time_model.arrival_time, stop_time_page.arrival_time
    assert_equal stop_time_model.stop_sequence, stop_time_page.stop_sequence
  end

  def test_add_stop_times_from_stop_time_pages
    stop_time_page1  = OpenStruct.new :arrival_time => '10:00 A.M.', :stop_page => OpenStruct.new, :stop_sequence => 7
    stop_time_page2  = OpenStruct.new :arrival_time => '11:00 A.M.', :stop_page => OpenStruct.new, :stop_sequence => 8
    trip_model       = Model::Trip.new
    stop_time_models = trip_model.add_stop_times_from_stop_time_pages [stop_time_page1, stop_time_page2]
    assert_equal 2, stop_time_models.size
  end
end
