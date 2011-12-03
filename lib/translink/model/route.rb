module Translink
  module Model
    class Route
      include DataMapper::Resource
      
      property :id,           Serial
      property :code,         String
      property :name,         String
      property :translink_id, Integer
      
      has n, :services
      has n, :stops, :through => :services
      
      def add_service_from_trip_page trip_page
        trip_page.trips.each do |trip|
          services << Service.build_from_trip(trip)
          services.last.save
        end
      end

      def self.find_or_add_from_route_page route_page
        first_or_create :code         => route_page.code,
                        :name         => route_page.name,
                        :translink_id => route_page.translink_id
      end
    end
  end
end
