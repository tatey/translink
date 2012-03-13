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

  def test_extract_from_summary_or_name_with_bang_sets_street1_street2_and_locality
    s1 = Model::Stop.new :summary => 'Grand Ave East, Grand Av opposite approaching Ascot Av'
    s1.extract_from_summary_or_name!
    assert_equal 'Grand Av', s1.street1
    assert_equal 'Ascot Av', s1.street2
    assert_equal 'opposite_approaching', s1.locality
    s2 = Model::Stop.new :summary => 'P.A. Hospital - 14, Ipswich Rd opposite far side of Tottenham St'
    s2.extract_from_summary_or_name!
    assert_equal 'Ipswich Rd', s2.street1
    assert_equal 'Tottenham St', s2.street2
    assert_equal 'opposite_far_side', s2.locality
    s3 = Model::Stop.new :summary => 'Partridge, Partridge St opposite Tang St'
    s3.extract_from_summary_or_name!
    assert_equal 'Partridge St', s3.street1
    assert_equal 'Tang St', s3.street2
    assert_equal 'opposite', s3.locality
    s4 = Model::Stop.new :summary => 'Stop 66, Blunder Rd (approaching Ipswich Rd)'
    s4.extract_from_summary_or_name!
    assert_equal 'Blunder Rd', s4.street1
    assert_equal 'Ipswich Rd', s4.street2
    assert_equal 'approaching', s4.locality
    s5 = Model::Stop.new :summary => 'Waterstone, Illaweena St far side of Waterbrooke Crt'
    s5.extract_from_summary_or_name!
    assert_equal 'Illaweena St', s5.street1
    assert_equal 'Waterbrooke Crt', s5.street2
    assert_equal 'far_side', s5.locality
    s6 = Model::Stop.new :summary => 'Woolloongabba Platform 1, South East Busway At Main St'
    s6.extract_from_summary_or_name!
    assert_equal 'South East Busway', s6.street1
    assert_equal 'Main St', s6.street2
    assert_equal 'at', s6.locality
    s7 = Model::Stop.new :summary => 'Allamanda, Old Northern Rd (Near Allamanda Cres)'
    s7.extract_from_summary_or_name!
    assert_equal 'Old Northern Rd', s7.street1
    assert_equal 'Allamanda Cres', s7.street2
    assert_equal 'near', s7.locality
  end
end
