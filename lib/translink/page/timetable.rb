module Translink
  class Page::Timetable < Page
    def route_pages
      page.search('table tr td:first-child a').map do |anchor| 
        Route.new url_from_href(anchor['href'])
      end
    end
    
    def timetable_page date
      form = page.forms[1]        
      form.field_with(:name => 'TimetableDate').value = date.to_s
      self.class.new(url_from_href(form.action)).tap do |page|
        page.page = form.submit
      end
    end
  end
end
