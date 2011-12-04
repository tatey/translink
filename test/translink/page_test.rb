require 'helper'

class PageTest < MiniTest::Unit::TestCase
  def test_initialize 
    assert_equal 'http://localhost', Page.new('http://localhost').url.to_s
  end
  
  def test_agent
    assert_equal "Translink/#{VERSION} Ruby/#{RUBY_VERSION} (https://github.com/tatey/translink)", Page.new('http://localhost').agent.user_agent
  end
end
