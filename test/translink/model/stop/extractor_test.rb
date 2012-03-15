require 'helper'

class Model::Stop::ExtractorTest < MiniTest::Unit::TestCase
  def stub_extractor summary
    Model::Stop::Extractor.new OpenStruct.new(:summary => summary)
  end

  def test_extract!
    stop      = OpenStruct.new :summary => 'Grand Ave East, Grand Av opposite approaching Ascot Av'
    extractor = Model::Stop::Extractor.new stop
    assert_same stop, extractor.extract!
    assert_equal 'Grand Av', stop.street1
    assert_equal 'Ascot Av', stop.street2
    assert_equal 'opposite_approaching', stop.locality
  end

  def test_street1_opposite_approaching
    assert_equal 'Grand Av', stub_extractor('Grand Ave East, Grand Av opposite approaching Ascot Av').street1
  end

  def test_street2_opposite_approaching
    assert_equal 'Ascot Av', stub_extractor('Grand Ave East, Grand Av opposite approaching Ascot Av').street2
  end

  def test_locality_opposite_approaching
    assert_equal 'opposite_approaching', stub_extractor('Grand Ave East, Grand Av opposite approaching Ascot Av').locality
  end

  def test_street1_opposite_far_side
    assert_equal 'Ipswich Rd', stub_extractor('P.A. Hospital - 14, Ipswich Rd opposite far side of Tottenham St').street1
  end

  def test_street2_opposite_far_side
    assert_equal 'Tottenham St', stub_extractor('P.A. Hospital - 14, Ipswich Rd opposite far side of Tottenham St').street2
  end

  def test_locality_opposite_far_side
    assert_equal 'opposite_far_side', stub_extractor('P.A. Hospital - 14, Ipswich Rd opposite far side of Tottenham St').locality
  end

  def test_street1_opposite
    assert_equal 'Partridge St', stub_extractor('Partridge, Partridge St opposite Tang St').street1
  end

  def test_street2_opposite
    assert_equal 'Tang St', stub_extractor('Partridge, Partridge St opposite Tang St').street2
  end

  def test_locality_opposite
    assert_equal 'opposite', stub_extractor('Partridge, Partridge St opposite Tang St').locality
  end

  def test_street1_appraoching
    assert_equal 'Blunder Rd', stub_extractor('Stop 66, Blunder Rd (approaching Ipswich Rd)').street1
  end

  def test_street2_appraoching
    assert_equal 'Ipswich Rd', stub_extractor('Stop 66, Blunder Rd (approaching Ipswich Rd)').street2
  end

  def test_locality_appraoching
    assert_equal 'approaching', stub_extractor('Stop 66, Blunder Rd (approaching Ipswich Rd)').locality
  end

  def test_street1_far_side
    assert_equal 'Illaweena St', stub_extractor('Waterstone, Illaweena St far side of Waterbrooke Crt').street1
  end

  def test_street2_far_side
    assert_equal 'Waterbrooke Crt', stub_extractor('Waterstone, Illaweena St far side of Waterbrooke Crt').street2
  end

  def test_locality_far_side
    assert_equal 'far_side', stub_extractor('Waterstone, Illaweena St far side of Waterbrooke Crt').locality
  end

  def test_street1_at
    assert_equal 'South East Busway', stub_extractor('Woolloongabba Platform 1, South East Busway At Main St').street1
  end

  def test_street2_at
    assert_equal 'Main St', stub_extractor('Woolloongabba Platform 1, South East Busway At Main St').street2
  end

  def test_locality_at
    assert_equal 'at', stub_extractor('Woolloongabba Platform 1, South East Busway At Main St').locality
  end

  def test_street1_near
    assert_equal 'Old Northern Rd', stub_extractor('Allamanda, Old Northern Rd (Near Allamanda Cres)').street1
  end

  def test_street2_near
    assert_equal 'Allamanda Cres', stub_extractor('Allamanda, Old Northern Rd (Near Allamanda Cres)').street2
  end

  def test_locality_near
    assert_equal 'near', stub_extractor('Allamanda, Old Northern Rd (Near Allamanda Cres)').locality
  end
end
