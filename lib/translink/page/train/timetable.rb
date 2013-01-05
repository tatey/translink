module Translink
  class Page::Train::Timetable < Page
    def route_pages
      page.search('table tr td:first-child a').map do |anchor|
        Train::Route.new url_from_href(anchor['href']), anchor.text
      end
    end
  end
end
