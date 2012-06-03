module Translink
  class Page::Trip < Page
    class Stop
      attr_accessor :stop_id
      attr_accessor :stop_name

      def == other
        stop_id == other.stop_id &&
        stop_name == other.stop_name
      end

      def html! node_set
        anchor = node_set.search('td a').first
        anchor['href'] =~ /([^\/]+)$/
        @stop_id = $1
        @stop_name = anchor.text
        self
      end
    end

    class StopTime
      attr_accessor :arrival_time
      attr_accessor :stop
      attr_accessor :stop_sequence

      def initialize stop_sequence
        @stop_sequence = stop_sequence
      end
      
      def departure_time
        arrival_time
      end

      def html! node_set
        @stop         = Stop.new.html! node_set
        @arrival_time = node_set.search('td').first.text.sub('.', ':').sub(/(a|p)(m)$/, ' \1.M.').upcase # "12:25pm" -> "12:25 P.M"
        self
      end
    end

    attr_accessor :date # [Date] Date the trip runs on.

    # Creates a new trip.
    # 
    # @param url [String] URL to fetch the page from.
    # @param date [Date] Date the trip runs on.
    def initialize url, date
      super url
      @date = date.to_date
    end

    # Get the trip's direction of travel.
    #
    # @return [String] "inbound" or "outbound".
    def direction
      url.to_s =~ /((in|out)bound)/
      $1
    end

    # Get the trip's unique ID.
    #
    # @return [String]
    def trip_id
      url.to_s =~ /bound\/([^\/]+)/
      $1
    end

    # Get the trip's service ID.
    #
    # @return [String]
    def service_id
      url.to_s =~ /bound\/[^\/]+\/([^\/]+)/
      $1
    end

    # Builds an array of stop times.
    #
    # @return [Array<Page::Trip::StopTime>]
    def stop_times
      page.search('table#trip-details tbody tr').each_with_index.map do |table_row, index|
        StopTime.new(index).html! table_row
      end
    end
  end
end
