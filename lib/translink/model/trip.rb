module Translink
  module Model
    class Trip
      include DataMapper::Resource

      storage_names[:default] = 'trips'

      property :id,         Serial
      property :direction,  Integer # Travel in one direction (Regular) or the opposite (Goofy) direction.
      property :headsign,   String  # Name of the direction. Eg "Inbound".
      property :service_id, Integer # Service belongs to a trip. Assigned by Translink.
      property :trip_id,    Integer # Unique ID assigned by Translink.

      belongs_to :route

      has n, :stop_times

      # Creates a +Model::StopTime+ record and associates it with this
      # trip.
      #
      # @param stop_time_page [Page::Stop::StopTime] HTML page representing the
      #   stop-time.
      # @return [void]
      def add_stop_time_from_stop_time_page stop_time_page
        StopTime.new.tap do |stop_time|
          stop_time.trip = self
          stop_time.stop_time_page! stop_time_page
          stop_time.save
        end
      end

      def add_stop_times_from_stop_time_pages stop_time_pages
        stop_time_pages.map do |stop_time_page|
          add_stop_time_from_stop_time_page stop_time_page
        end
      end

      # Sets properties from the given +trip_page+. 
      #
      # @param trip_page [Trip::Page] HTML page that represents the trip.
      # @return [void]
      def trip_page! trip_page
        self.direction  = trip_page.direction
        self.headsign   = trip_page.headsign
        self.service_id = trip_page.service_id
        self.trip_id    = trip_page.trip_id
      end
    end
  end
end
