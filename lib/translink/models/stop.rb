module Translink
  module Model
    class Stop
      include DataMapper::Resource

      storage_names[:default] = 'stops'

      property :id,        String, :field => 'stop_id', :key => true, :unique => true, :unique_index => true
      property :stop_name, String
      property :stop_lat,  Float
      property :stop_lon,  Float

      has n, :stop_times

      # Stop model for the given +stop_page+. Will create the route if it
      # doesn't exist.
      #
      # @param route_pate [Page::Route] HTML page representing the stop.
      # @return [Model::Stop] DataMapper record.
      def self.find_or_add_from_stop_page stop_page
        first_or_create :id        => stop_page.stop_id,
                        :stop_name => stop_page.stop_name,
                        :stop_lat  => stop_page.stop_lat,
                        :stop_lon  => stop_page.stop_lon
      end
    end
  end
end
