require 'helper'

class CLITtest < MiniTest::Unit::TestCase
  def setup
    @out = StringIO.new
    @cli = CLI.new File.expand_path('../tmp', __FILE__)
    @cli.logger = Logger.new(@out).tap { |logger| logger.level = Logger::INFO }
  end
  
  def test_blank_executes_help_command
    @cli.run ''
    assert_match /help/, @out.string
  end
  
  def test_unrecognised_command_executes_help_command
    @cli.run 'unknown'
    assert_match /help/, @out.string
  end
  
  def test_help_command
    @cli.run 'help'
    assert_match /help/, @out.string
  end
end
