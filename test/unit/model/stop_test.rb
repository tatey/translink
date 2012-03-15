require 'helper'

class Model::StopTest < MiniTest::Unit::TestCase
  def test_find_or_add_from_stop
    DB.new 'sqlite::memory:' do
      stop = MiniTest::Mock.new
      stop.expect :name, 'Illaweena St (Waterstone)'
      stop.expect :summary, 'Waterstone, Illaweena St far side of Waterbrooke Crt'
      assert_equal Model::Stop.find_or_add_from_stop(stop), Model::Stop.find_or_add_from_stop(stop)
      assert_equal 1, Model::Stop.count
    end
  end

  def test_all
    DB.new 'sqlite::memory:' do
      Model::Stop.create :name => 'Adelaide St'
      Model::Stop.create :name => 'Queen St'
      Model::Stop.create :name => 'Elizabeth St'
      stops = Model::Stop.all
      assert_equal ['Adelaide St', 'Queen St', 'Elizabeth St'], stops.map(&:name)
    end
  end

  def test_extract!
    stop               = Model::Stop.new
    extractor_instance = MiniTest::Mock.new.expect :extract!, stop
    extractor_class    = MiniTest::Mock.new.expect :new, extractor_instance, [stop]
    stop.__extractor__ = extractor_class
    stop.extract!
    assert extractor_instance.verify
    assert extractor_class.verify
  end

  def test__extractor__
    assert_equal Model::Stop::Extractor, Model::Stop.new.__extractor__
  end
end
