module Translink
  module Model
    class Service
      include DataMapper::Resource
      
      property :id,   Serial
      property :time, DateTime
      
      belongs_to :route
      belongs_to :stop
      
      def self.build_from_trip trip
        new.tap do |service|
          service.stop = Stop.find_or_add_from_stop trip.stop
          service.time = trip.time
        end
      end
    end
  end
end
