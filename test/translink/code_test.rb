require 'helper'

class CodeTest < MiniTest::Unit::TestCase
  def test_brisbane
    refute Code.brisbane?('10')
    assert Code.brisbane?('100')
    assert Code.brisbane?('499')
    assert Code.brisbane?('GLIDER')
    assert Code.brisbane?('LOOP')
    refute Code.brisbane?('500')
  end
end
