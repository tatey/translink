module Translink
  module Model
    class Stop
      include DataMapper::Resource

      storage_names[:default] = 'stops'

      property :id,        Serial
      property :stop_id,   Integer
      property :stop_name, String

      has n, :stop_times

      def self.find_or_add_from_stop_page stop_page
        first_or_create :stop_id   => stop_page.stop_id,
                        :stop_name => stop_page.stop_name
      end
    end
  end
end
