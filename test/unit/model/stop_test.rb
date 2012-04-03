require 'helper'

class Model::StopTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_stop
    DB.context 'sqlite::memory:', :migrate => true do
      stop = MiniTest::Mock.new
      stop.expect :name, 'Illaweena St (Waterstone)'
      stop.expect :summary, 'Waterstone, Illaweena St far side of Waterbrooke Crt'
      assert_equal Model::Stop.find_or_add_from_stop(stop), Model::Stop.find_or_add_from_stop(stop)
      assert_equal 1, Model::Stop.count
    end
  end

  def test_all
    DB.context 'sqlite::memory:', :migrate => true do
      Model::Stop.create :name => 'Adelaide St'
      Model::Stop.create :name => 'Queen St'
      Model::Stop.create :name => 'Elizabeth St'
      stops = Model::Stop.all
      assert_equal ['Adelaide St', 'Queen St', 'Elizabeth St'], stops.map(&:name)
    end
  end
end
