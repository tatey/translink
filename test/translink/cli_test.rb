require 'helper'

class CLITtest < MiniTest::Unit::TestCase
  def setup
    @cli = CLI.new File.expand_path('../tmp', __FILE__)
  end
  
  def test_unrecognised_command_executes_help
    assert_match /help/i, capture { @cli.run '' }
    assert_match /help/i, capture { @cli.run 'unknown' }    
  end
  
  def test_help_command
    assert_match /help/i, capture { @cli.run 'help' }
  end
end
