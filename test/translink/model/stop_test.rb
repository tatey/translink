require 'helper'

class Model::StopTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_stop
    DB.new('sqlite::memory:').use do 
      stop = MiniTest::Mock.new
      stop.expect :name, '130'
      stop.expect :locality, 'City Buz 130 Via Sunnybank'
      assert_equal Model::Stop.find_or_add_from_stop(stop), Model::Stop.find_or_add_from_stop(stop)
      assert_equal 1, Model::Stop.count
    end
  end
end
