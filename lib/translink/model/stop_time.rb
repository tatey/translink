module Translink
  module Model
    class StopTime
      include DataMapper::Resource

      storage_names[:default] = 'stop_times'

      property :arrival_time,  String, :key => true
      property :stop_sequence, Integer
      property :stop_id,       String, :key => true
      property :trip_id,       String, :key => true

      belongs_to :stop
      belongs_to :trip

      # Sets attributes from the +stop_time_page+.
      #
      # @param stop_time_page [Page::Stop::StopTime]
      # @return [void]
      def stop_time_page! stop_time_page
        self.arrival_time  = stop_time_page.arrival_time
        self.stop          = Stop.find_or_add_from_stop_page stop_time_page.stop_page
        self.stop_sequence = stop_time_page.stop_sequence
      end
    end
  end
end
