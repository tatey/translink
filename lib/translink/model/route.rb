module Translink
  module Model
    class Route
      include DataMapper::Resource
      
      property :id,           Serial
      property :code,         String
      property :name,         String
      property :translink_id, Integer
      
      has n, :services
      
      def self.find_or_add route_page
        first_or_create :code         => route_page.code,
                        :name         => route_page.name,
                        :translink_id => route_page.translink_id
      end
      
      def add_services services
        self.services << services
      end
    end
  end
end
