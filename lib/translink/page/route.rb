module Translink
  class Page::Route < Page
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
      page.search('h1').first.text.sub('Route ', '')
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
        Trip.new url_from_href(anchor[:href])
      end
    end
  end
end
