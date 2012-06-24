module Translink
  class Page::Trip < Page
    class Stop
      attr_accessor :stop_id   # [String] Unique ID.
      attr_accessor :stop_name # [String] Eg: "Queen Street station, platform A6".
      attr_accessor :stop_lat  # [String] Eg: "27.470677".
      attr_accessor :stop_lon  # [String] Eg: "153.024747".

      # Tests equality with +other+. Considered equal if +stop_id+ and 
      # +stop_name+ are equal.
      #
      # @param other [Page::Trip::Stop] Stop to compare.
      # @return [TrueClass, FalseClass] 
      def == other
        stop_id == other.stop_id &&
        stop_name == other.stop_name
      end

      # Sets attributes by extracting attributes from the HTML fragment.
      #
      # @param node_set [Nokogiri::XML::NodeSet] The HTML fragment to search.
      # @return [Page::Trip::Stop] 
      def html! node_set
        anchor = node_set.search('td a').first
        anchor['href'] =~ /([^\/]+)$/
        @stop_id = $1
        @stop_name = anchor.text
        @stop_lat, @stop_lon = node_set['data-position'].split(',')
        self
      end
    end

    class StopTime
      attr_accessor :arrival_time  # [String] The time the vehicle arrives at the +stop+.
      attr_accessor :stop_page     # [Page::Trip::Stop] Stop associated with the +arrival_time+.
      attr_accessor :stop_sequence # [Integer] Order in which this stop is visited in the trip.

      # Creates a new stop time.
      #
      # @param stop_sequence [Integer] Order in which this stop is visited.
      def initialize stop_sequence
        @stop_sequence = stop_sequence
      end
      
      # Time vehicle starts from the +stop+. Translink doesn't provide an
      # explicit +departure_time+ so we use the +arrival_time+.
      #
      # @return [String] Eg: "10:00 A.M."
      def departure_time
        arrival_time
      end

      # Sets attributes by extracting attributes from the HTML fragment.
      #
      # @param node_set [Nokogiri::XML::NodeSet] The HTML fragment to search.
      # @return [Page::Trip::Stop] 
      def html! node_set
        @stop_page    = Stop.new.html! node_set
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
      url.to_s =~ /information\/([a-z]+)\//
      $1
    end

    # Get the trip's unique ID.
    #
    # @return [String]
    def trip_id
      url.to_s =~ /information\/[a-z]+\/([^\/]+)/
      $1
    end

    # Get the trip's service ID.
    #
    # @return [String]
    def service_id
      url.to_s =~ /information\/[a-z]+\/[^\/]+\/([^\/]+)/
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
