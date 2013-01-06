require 'helper'

class Model::StopTimeTest < MiniTest::Unit::TestCase
  def test_stop_time_page_with_bang
    stop_time_page  = OpenStruct.new :arrival_time => '10:00 A.M.', :stop_page => OpenStruct.new, :stop_sequence => 7
    stop_time_model = Model::StopTime.new
    stop_time_model.stop_time_page! stop_time_page
    assert_equal stop_time_page.arrival_time, stop_time_model.arrival_time   
    assert_equal stop_time_page.stop_sequence, stop_time_model.stop_sequence
  end
end
