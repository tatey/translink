module Translink
  module Model
    class Service
      include DataMapper::Resource
      
      property :id,   Serial
      property :time, DateTime
      
      belongs_to :route
      belongs_to :stop
    end
  end
end
