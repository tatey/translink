require 'helper'

class CLITtest < MiniTest::Unit::TestCase
  TMPDIR = File.expand_path '../../../tmp', __FILE__
  
  class Crawler
    def initialize url

    end
    
    def crawl date

    end
  end

  def setup
    @out = StringIO.new
    @cli = CLI.new(TMPDIR).tap do |cli|
      cli.crawler_class = Crawler
      cli.out           = @out
    end
  end
  
  def teardown
    pattern = File.join TMPDIR, '*.sqlite3'
    Dir[pattern].each { |file| FileUtils.rm_rf file }
  end
  
  def test_blank_executes_help_command
    @cli.run ''
    assert_match /help/, @out.string
  end
  
  def test_unrecognised_command_executes_help_command
    @cli.run 'unknown'
    assert_match /help/, @out.string
  end
  
  def test_execute_help_command
    @cli.run 'help'
    assert_match /help/, @out.string
  end
  
  def test_execute_import_command_with_uri
    file = File.join TMPDIR, 'test.sqlite3'
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run "import 2011-11-27 --uri=sqlite://#{file}"
    assert File.exists?(file), 'Expected file to exist.'
  end

  def test_execute_import_command_with_date_writes_sqlite_database
    file = File.join TMPDIR, '2011-11-27.sqlite3'
    refute File.exists?(file), 'Expected file not to exist.'
    @cli.run 'import 2011-11-27'
    assert File.exists?(file), 'Expected file to exist.'
  end
  
  def test_execute_import_command_without_date_executes_help_command
    @cli.run 'import'
    assert_match /help/, @out.string
  end
end
