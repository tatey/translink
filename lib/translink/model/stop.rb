module Translink
  module Model
    class Stop
      include DataMapper::Resource
      
      property :id,       Serial
      property :name,     String
      property :locality, String
      
      has n, :services    
      has n, :routes, :through => :services      
    end
  end
end
