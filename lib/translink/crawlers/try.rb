module Translink
  module Crawler
    module Try
      def self.included base
        base.extend ClassMethods
      end

      def try retry_count = 1, &block
        block.call
      rescue => exception
        if retry_count < self.class.retry_count
          sleep self.class.sleep_duration * retry_count
          try retry_count + 1, &block
        end
      end

      module ClassMethods
        def retry_count
          2
        end

        def sleep_duration
          5
        end
      end
    end
  end
end
