module Translink
  module Model
    class Stop
      include DataMapper::Resource

      storage_names[:default] = 'stops'

      property :id,        Serial
      property :stop_id,   Integer
      property :stop_name, String

      has n, :stop_times

      # Stop model for the given +stop_page+. Will create the route if it
      # doesn't exist.
      #
      # @param route_pate [Page::Route] HTML page representing the stop.
      # @return [Model::Stop] DataMapper record.
      def self.find_or_add_from_stop_page stop_page
        first_or_create :stop_id   => stop_page.stop_id,
                        :stop_name => stop_page.stop_name
      end
    end
  end
end
