module Translink
  module Model
    class Trip
      include DataMapper::Resource

      storage_names[:default] = 'trips'

      property :id,         Serial
      property :direction,  String
      property :service_id, Integer
      property :trip_id,    Integer

      belongs_to :route

      # Sets properties from the given +trip_page+. 
      #
      # @param trip_page [Trip::Page] HTML page that represents the trip.
      # @return [void]
      def trip_page! trip_page
       self.direction  = trip_page.direction
       self.service_id = trip_page.service_id
       self.trip_id    = trip_page.trip_id
      end
    end
  end
end
