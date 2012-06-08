module Translink
  module Model
    class Route
      include DataMapper::Resource

      storage_names[:default] = 'routes'

      property :id,           Serial
      property :code,         String
      property :name,         String
      property :direction,    String
      property :translink_id, Integer

      has n, :services
      has n, :stops, :through => :services

      def self.find_or_add_from_route_page route_page
        first_or_create :code         => route_page.code,
                        :name         => route_page.name,
                        :direction    => route_page.direction,
                        :translink_id => route_page.translink_id
      end
    end
  end
end
