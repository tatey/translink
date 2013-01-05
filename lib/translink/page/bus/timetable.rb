module Translink
  class Page::Bus::Timetable < Page
    # Builds an unique array of route pages.
    #
    # @param url [URI] Omit routes before the route with +url+.
    # @return [Array<Page::Bus::Route>]
    def route_pages url = nil, step = nil
      routes = page.search('table tr td:last-child a').reduce(Array.new) do |routes, anchor|
        route     = Route.new url_from_href(anchor['href']), anchor.text
        duplicate = routes.find { |duplicate| duplicate.url == route.url }
        routes << route unless duplicate
        routes
      end
      if url
        routes.drop_while { |route| route.url != url }.slice 0..(step || routes.size)
      else
        routes
      end
    end

    # Returns a timetable page with routes running on the given date.
    #
    # @param timestamp [DateTime] Filter by this date.
    #   TZ should be Australia/Brisbane and the time should be at midnight.
    # @return [Timetable]
    def timetable_page timestamp
      form  = page.forms[1]
      value = timestamp.strftime('%-d/%m/%y %I:%M:%S %p') # Eg: "4/06/2012 12:00:00 AM"
      form.field_with(:name => 'Date').value = value
      self.class.new(url_from_href(form.action)).tap do |page|
        page.page = form.submit
      end
    end
  end
end
