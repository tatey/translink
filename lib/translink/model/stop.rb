module Translink
  module Model
    class Stop
      include DataMapper::Resource

      storage_names[:default] = 'stops'

      property :id,       Serial
      property :name,     String
      property :summary,  String

      has n, :services
      has n, :routes, :through => :services

      def self.find_or_add_from_stop stop
        Stop.first_or_create :name => stop.name, :summary => stop.summary
      end
    end
  end
end
