module Translink
  module Model
    class Stop::Extractor
      REGEXES = {
        /[\s\(]opposite approaching/i => 'opposite_approaching',
        /[\s\(]opposite far side of/i => 'opposite_far_side',
        /[\s\(]opposite/i             => 'opposite',
        /[\s\(]approaching/i          => 'approaching',
        /[\s\(]far side of/i          => 'far_side',
        /[\s\(]at/i                   => 'at',
        /[\s\(]near/i                 => 'near'
      }

      attr_accessor :stop

      def initialize stop
        @stop = stop
      end

      def extract!
        stop.street1  = street1
        stop.street2  = street2
        stop.locality = locality
        stop
      end

      def street1
        segment = segments.first
        segment =~ /,\s*(.+)/
        ($1 || segment).strip
      end

      def street2
        segments.last.gsub(/[\(\)]/, '').strip
      end

      def locality
        REGEXES[regex]
      end

    protected

      def regex
        REGEXES.keys.find { |regex| summary_or_name =~ regex }
      end

      def segments
        summary_or_name.split regex
      end

      def summary_or_name
        stop.summary ? stop.summary : stop.name
      end
    end
  end
end
