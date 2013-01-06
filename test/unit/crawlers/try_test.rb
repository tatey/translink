require 'helper'

class Translink::Crawler::TryDefaultsTest < MiniTest::Unit::TestCase
  class MockCrawler
    include Crawler::Try
  end

  def test_retry_count_default
    assert_equal 2, MockCrawler.retry_count
  end

  def test_sleep_duration_default
    assert_equal 5, MockCrawler.sleep_duration
  end
end

class Translink::Crawler::TryExceptionTest < MiniTest::Unit::TestCase
  class MockCrawler
    include Crawler::Try

    def self.retry_count
      2
    end

    def self.sleep_duration
      0
    end

    def initialize
      @count = 0
    end

    def count
      @count
    end

    def crawl out
      try out do
        @count = @count + 1
        raise StandardError, 'Exceptionally exceptional'
      end
    end
  end

  def test_try_writes_to_out
    out     = StringIO.new
    crawler = MockCrawler.new
    crawler.crawl out
    assert_match /Exceptionally exceptional/, out.string
  end

  def test_try_retries_until_retry_count
    crawler = MockCrawler.new
    crawler.crawl StringIO.new
    assert_equal 2, crawler.count
  end
end