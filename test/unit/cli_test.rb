require 'helper'

class CLITtest < MiniTest::Unit::TestCase
  TMPDIR = File.expand_path '../../tmp', __FILE__

  class Crawler
    def initialize url

    end

    def crawl date, from_route_url = nil, step = nil

    end
  end

  def setup
    @out = StringIO.new
    @cli = CLI.new(TMPDIR).tap do |cli|
      cli.__crawler__ = Crawler
      cli.out         = @out
    end
  end

  def teardown
    pattern = File.join TMPDIR, '*.sqlite3'
    Dir[pattern].each { |file| FileUtils.rm_rf file }
  end

  def test_blank_executes_help_command
    @cli.run ''
    assert_includes @out.string, 'Usage'
  end

  def test_unrecognised_command_executes_help_command
    @cli.run 'unknown'
    assert_includes @out.string, 'Usage'
  end

  def test_execute_help_command
    @cli.run 'help'
    assert_includes @out.string, 'Usage'
  end

  def test_execute_scape_command_with_date
    file = File.join TMPDIR, '2011-11-27.sqlite3'
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run 'scrape 2011-11-27'
    assert File.exists?(file), 'Expected file to exist.'
  end

  def test_execute_scape_command_with_date_and_db_path
    file = File.join TMPDIR, "test_db_path_#{Time.now.to_i}.sqlite3"
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run "scrape 2011-11-27 #{file}"
    assert File.exists?(file), 'Expected file to exist.'
  end

  def test_execute_scrape_command_with_date_db_path_and_from_route_url
    file = File.join TMPDIR, "test_db_path_from_route_url_#{Time.now.to_i}.sqlite3"
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run "scrape 2011-11-27 #{file} http://localhost"
    assert File.exists?(file), 'Expected file to exist.'
  end

  def test_execute_scrape_command_with_date_db_path_from_route_url_and_step
    file = File.join TMPDIR, "test_db_path_from_route_url_step_#{Time.now.to_i}.sqlite3"
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run "scrape 2011-11-27 #{file} http://localhost 0"
    assert File.exists?(file), 'Expected file to exist.'
  end

  def test_version_command
    @cli.run 'version'
    assert_match Translink::VERSION, @out.string
  end

  def test_execute_scrape_command_without_date_executes_help_command
    @cli.run 'scrape'
    assert_includes @out.string, 'Usage'
  end
end
