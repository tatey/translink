require 'helper'

class Model::ServiceTest < MiniTest::Unit::TestCase
  class Trip
    def stop
      Model::Stop.first_or_create :name => 'Stop'
    end
    
    def time
      DateTime.parse '2011-12-03 18:24:00'
    end
  end
  
  def test_build_from_trip
    DB.new('sqlite::memory:').use do
      trip    = Trip.new
      service = Model::Service.build_from_trip trip
      assert_equal trip.stop, service.stop
      assert_equal trip.time, service.time
      assert_instance_of Model::Service, service
    end
  end
end
