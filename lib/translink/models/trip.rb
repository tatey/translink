module Translink
  module Model
    class Trip
      include DataMapper::Resource

      storage_names[:default] = 'trips'

      # Primary key. Unique ID is a combination of route_id and trip_id.
      property :id, String, :field => 'trip_id', :key => true, :unique => true, :unique_index => true

      # Travel in one direction (Regular) or the opposite (Goofy) direction.
      property :direction, Integer

      # Name of the direction. Eg "Inbound".
      property :headsign, String

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
        self.id         = trip_page.unique_trip_id
        self.direction  = trip_page.direction
        self.headsign   = trip_page.headsign
      end
    end
  end
end
