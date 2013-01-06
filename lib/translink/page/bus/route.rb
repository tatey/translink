module Translink
  class Page::Bus::Route < Page
    attr_reader :long_name # [String] Usually a list of suburbs.

    # Creates a new route.
    #
    # @param url [String] URL to fetch the page from.
    # @param name [String] Route's long name.
    def initialize url, long_name
      super url
      @long_name = long_name
    end

    # Get the route's unique ID assigned by Translink. This is the same
    # as the +short_name+.
    #
    # @return [String]
    def route_id
      @route_id ||= page.search('div#headingBar h1').first.text.sub('Route ', '')
    end

    # Gets the route's code.
    #
    # @return [String]
    def short_name
      case route_id
      when 'CGLD'
        'CityGlider'
      when 'LOOP'
        'City Loop'
      when 'SHLP'
        'Spring Hill City Loop'
      else
        route_id
      end
    end

    # Get the date this route is running. Trip pages are bound by this
    # date.
    #
    # @return [DateTime]
    def date
      DateTime.parse page.search('select#TimetableDate option[selected]').first['value']
    end

    # Get headsigns of directions travelled by this route.
    #
    # @return [Array<String>]
    def headsigns
      page.search('h3').map { |node| node.text.downcase }.uniq
    end

    # Get the direction of travel for the given +anchor+.
    #
    # @param anchor [Nokogiri::XML::Node] Anchor to ascend from.
    # @return [Integer] +0+ for one (Regular) direction of travel, +1+ for
    #   opposite (Goofy) direction of travel.
    def direction_from_anchor anchor
      headsigns.index anchor.ancestors('div.route-timetable').search('h3').first.text.downcase
    end

    # Get the date of the trip. If the trip does not have a date, the UNIX
    # epoc is returned.
    #
    # Examples:
    #
    #   "/travel-information/network-information/service-information/outbound/9792/2173523/2012-09-24"
    #   ... becomes
    #   DateTime.new('2012-09-24')
    #
    #   "/travel-information/network-information/service-information/outbound/9792/2173523"
    #   ... becomes
    #   DateTime.new('1970-01-01')
    #
    # @return [DateTime]
    def date_from_anchor anchor
      match = anchor[:href].match /\d{4}-\d{2}-\d{2}$/
      date  = match ? match[0] : '1970-01-01'
      DateTime.parse date
    end

    # Builds an array of trip pages.
    #
    # @return [Array<Page::Trip>]
    def trip_pages
      page.search('a.map-link-top').select do |anchor|
        date_from_anchor(anchor) == date
      end.map do |anchor|
        Trip.new url_from_href(anchor[:href]), date, direction_from_anchor(anchor), route_id
      end
    end

    def route_type
      3
    end
  end
end
