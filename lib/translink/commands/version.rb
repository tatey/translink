module Translink
  module Command
    class Version
      def self.run out, argv
        out.puts VERSION
      end
    end
  end
end
