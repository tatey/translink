module Translink
  module Model
    class Service
      include DataMapper::Resource
      
      property :id,   Serial
      property :time, DateTime
      
      belongs_to :route
    end
  end
end
