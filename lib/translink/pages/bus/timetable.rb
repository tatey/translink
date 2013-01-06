module Translink
  module Page
    module Bus
      class Timetable < Base
        def self.timetable_page url, date
          new(url).timetable_page(date)
        end

        def route_pages
          page.search('table tr td:last-child a').reduce(Array.new) do |routes, anchor|
            route     = Bus::Route.new url_from_href(anchor['href']), anchor.text
            duplicate = routes.find { |duplicate| duplicate.url == route.url }
            routes << route unless duplicate
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
  end
end
