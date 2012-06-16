module Translink
  module Model
    class StopTime
      include DataMapper::Resource

      storage_names[:default] = 'stop_times'

      property :id,            Serial
      property :arrival_time,  String
      property :stop_sequence, Integer

      belongs_to :stop
      belongs_to :trip

      def stop_time_page! stop_time_page
        self.arrival_time  = stop_time_page.arrival_time
        self.stop          = Stop.find_or_add_from_stop_page stop_time_page.stop_page
        self.stop_sequence = stop_time_page.stop_sequence
      end
    end
  end
end
