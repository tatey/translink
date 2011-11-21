module Translink
  module Model
    class Route
      include DataMapper::Resource
      
      property :id,           Serial
      property :code,         String
      property :name,         String
      property :translink_id, Integer
      
      has n, :services
    end
  end
end
