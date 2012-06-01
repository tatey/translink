module Translink
  class Page::Timetable < Page
    # Builds an array of route pages.
    #
    # @return [Array(Page::Route)]
    def route_pages
      page.search('table tr td:last-child a').reduce Array.new do |pages, anchor|
        route = Route.new url_from_href(anchor['href'])
        pages << route
        pages
      end
    end

    # Returns a timetable page with routes running on the given date.
    #
    # @param timestamp [DateTime] Filter by this date.
    #   TZ should be Australia/Brisbane and the time should be at midnight.
    # @return [Timetable]
    def timetable_page timestamp
      form  = page.forms[0]
      value = timestamp.strftime('%-d/%m/%y %I:%M:%S %p') # Eg: "4/06/2012 12:00:00 AM"
      form.field_with(:name => 'Date').value = value
      self.class.new(url_from_href(form.action)).tap do |page|
        page.page = form.submit
      end
    end
  end
end
