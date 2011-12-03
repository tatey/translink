require 'helper'

class Model::StopTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_stop
    DB.new 'sqlite::memory:' do 
      stop = MiniTest::Mock.new
      stop.expect :name, 'Illaweena St (Waterstone)'
      stop.expect :locality, 'Waterstone, Illaweena St far side of Waterbrooke Crt'
      assert_equal Model::Stop.find_or_add_from_stop(stop), Model::Stop.find_or_add_from_stop(stop)
      assert_equal 1, Model::Stop.count
    end
  end
end
