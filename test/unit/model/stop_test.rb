require 'helper'

class Model::StopTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_stop_page
    DB.context 'sqlite::memory:', :migrate => true do
      stop_page = OpenStruct.new :stop_id => 001002, :stop_name => 'Queen Street station, platform A6'
      assert_equal 0, Model::Stop.count 
      assert_equal Model::Stop.find_or_add_from_stop_page(stop_page), Model::Stop.find_or_add_from_stop_page(stop_page)
      assert_equal 1, Model::Stop.count 
    end
  end
end
