require 'helper'

class CLITtest < MiniTest::Unit::TestCase
  TMPDIR = File.expand_path '../tmp', __FILE__
  
  def Crawler
    def initialize url

    end
    
    def crawl
      
    end
  end
  
  def setup
    @out               = StringIO.new
    @cli               = CLI.new TMPDIR
    @cli.crawler_class = Crawler
    @cli.logger        = Logger.new(@out).tap { |logger| logger.level = Logger::INFO }
  end
  
  def teardown
    Dir[TMPDIR].reject { |file| File.extname(file) == '.gitkeep' }.each { |file| FileUtils.rm_rf file }
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
  
  def test_execute_scrape_command_with_uri
    file = File.join TMPDIR, 'test.sqlite3'
    refute File.exists? file
    @cli.run "scrape 2011-11-27 --uri=#{file}"
    assert File.exists? file
  end

  def test_execute_scrape_command_with_date_writes_sqlite_database
    file = File.join TMPDIR, '2011-11-27.sqlite3'
    refute File.exists? file
    @cli.run "scrape 2011-11-27"
    assert File.exists? file
  end
  
  def test_execute_scrape_command_without_date_executes_help_command
    @cli.run "scrape"
    assert_match /help/, @out.string
  end
end
