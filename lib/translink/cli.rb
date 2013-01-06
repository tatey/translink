module Translink
  class CLI
    attr_accessor :default
    attr_reader   :commands
    attr_reader   :out

    def initialize out
      @commands = {}
      @out      = out
    end

    def register_command name, command
      commands[name] = command
    end

    def run argv
      name    = commands.keys.find { |name| name == argv[0] } || default
      command = commands[name]
      command.run out, argv[1..-1]
    end

    def self.default
      new($stdout).tap do |cli|
        cli.register_command 'help', Command::Help
        cli.register_command 'route', Command::Route
        cli.register_command 'timetable', Command::Timetable
        cli.register_command 'version', Command::Version
        cli.default = 'help'
      end
    end
  end
end
