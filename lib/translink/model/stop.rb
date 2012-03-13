module Translink
  module Model
    class Stop
      include DataMapper::Resource

      REGEXES = {
        /[\s\(]opposite approaching/i => 'opposite_approaching',
        /[\s\(]opposite far side of/i => 'opposite_far_side',
        /[\s\(]opposite/i             => 'opposite',
        /[\s\(]approaching/i          => 'approaching',
        /[\s\(]far side of/i          => 'far_side',
        /[\s\(]at/i                   => 'at',
        /[\s\(]near/i                 => 'near'
      }

      property :id,       Serial
      property :name,     String
      property :summary,  String
      property :street1,  String
      property :street2,  String
      property :locality, String
      
      has n, :services    
      has n, :routes, :through => :services      
      
      def self.find_or_add_from_stop stop
        Stop.first_or_create :name => stop.name, :summary => stop.summary
      end

      def extract_from_summary_or_name!
        segments = summary_or_name.split regex
        if segments.size == 2
          self.street1  = sanitize_street1 segments[0]
          self.street2  = sanitize_street2 segments[1]
          self.locality = REGEXES[regex]
        else
          self.street1  = summary_or_name.strip
          self.street2  = nil
          self.locality = nil
        end
      end

    protected

      def regex
        REGEXES.keys.find { |regex| summary_or_name =~ regex }
      end

      def sanitize_street1 street
        match_data = street.match /,\s*(.+)/
        if match_data && match_data[1]
          match_data[1].strip
        else
          street.strip
        end
      end

      def sanitize_street2 street
        street.gsub(/[\(\)]/, '').strip
      end

      def summary_or_name
        summary ? summary : name
      end
    end
  end
end
