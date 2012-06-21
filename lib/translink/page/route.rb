module Translink
  class Page::Route < Page
    class UnknownRouteTypeError < StandardError
    end

    ROUTE_TYPES = {'buses' => 3, 'ferries' => 4, 'trains' => 0} # Maps to Google Transit route type.

    attr_reader :long_name # [String] Usually a list of suburbs.

    # Creates a new route.
    #
    # @param url [String] URL to fetch the page from.
    # @param name [String] Route's long name.
    def initialize url, long_name
      super url
      @long_name = long_name
    end

    # Gets the route's code.
    #
    # @return [String]
    def short_name
      page.search('div#headingBar h1').first.text.sub('Route ', '')
    end

    # Get the date this route is running. Trip pages are bound by this
    # date.
    #
    # @return [DateTime]
    def date
      DateTime.parse page.search('select#TimetableDate option[selected]').first['value']
    end

    # Builds an array of trip pages.
    #
    # @return [Array<Page::Trip>]
    def trip_pages
      page.search('a.map-link-top').map do |anchor|
        Trip.new url_from_href(anchor[:href]), date
      end
    end

    # Get the type of transportation used on the route.
    #
    # @return [Integer]
    # @raise [UnknownRouteTypeError] if the route type is not defined in 
    #   +ROUTE_TYPES+.
    def route_type
      url.to_s =~ /(buses|ferries|trains)/
      ROUTE_TYPES.fetch($1) { raise UnknownRouteTypeError }
    end
  end
end
