require 'helper'

class PageTest < MiniTest::Unit::TestCase
  def test_initialize 
    assert_equal 'http://localhost', Page.new('http://localhost').url.to_s
  end
end
