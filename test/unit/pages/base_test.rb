require 'helper'

class Page::BaseTest < MiniTest::Unit::TestCase
  def test_initialize 
    assert_equal 'http://localhost', Page::Base.new('http://localhost').url.to_s
  end

  def test_agent
    assert_equal "Mozilla/5.0 (Translink/#{VERSION} Ruby/#{RUBY_VERSION} (https://github.com/tatey/translink))", Page::Base.new('http://localhost').agent.user_agent
  end
end
