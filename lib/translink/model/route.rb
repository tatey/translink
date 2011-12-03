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
      
      def add_services_from_trip_pages *trip_pages
        trip_pages.each do |trip_page|
          trip_page.trips.each do |trip|     
            services.new.tap do |service|
              service.stop = Stop.new :name => trip.stop.name, :locality => trip.stop.locality
              service.time = trip.time
            end.save
          end
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
