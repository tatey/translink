module Translink
  module Model
    class Route
      include DataMapper::Resource

      storage_names[:default] = 'routes'

      property :id,         Serial
      property :route_id,   Integer # Unique ID assigned by Translink.
      property :short_name, String  # Route code. Eg "130".
      property :long_name,  String  # Suburbs serviced or destination. Eg "City, Sunnybank, Algester". 
      property :route_type, Integer # Type of transporation. Eg "Bus".

      has n, :trips

      # Route model for the given +route_page+. Will create the route if it
      # doesn't exist.
      #
      # @param route_pate [Page::Route] HTML page that represents the route.
      # @return [Model::Route] DataMapper record.
      def self.find_or_add_route_from_route_page route_page
        first_or_create :route_id   => route_page.route_id,
                        :short_name => route_page.short_name,
                        :long_name  => route_page.long_name,
                        :route_type => route_page.route_type
      end

      # Create a trip.
      #
      # @param trip_page [Page::Trip] HTML page that represents the trip.
      # @return [Model::Trip] DataMapper record.
      def add_trip_from_trip_page trip_page
        Trip.new.tap do |trip|
          trip.route = self
          trip.trip_page! trip_page
          trip.save
        end
      end
    end
  end
end
