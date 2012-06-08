module Translink
  module Model
    class Trip
      include DataMapper::Resource

      storage_names[:default] = 'trips'

      property :id,         Serial
      property :direction,  Integer
      property :service_id, Integer
      property :trip_id,    Integer

      belongs_to :route
    end
  end
end
