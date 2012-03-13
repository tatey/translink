module Translink
  class Page::Timetable < Page
    attr_accessor :code_class

    def code_class
      @code_class ||= Code
    end

    def route_pages
      page.search('table tr td:first-child a').reduce Array.new do |pages, anchor|
        route = Route.new url_from_href anchor['href']
        pages << route if code_class.brisbane? extract_code_from_anchor(anchor)
        pages
      end
    end
    
    def timetable_page date
      form = page.forms[1]        
      form.field_with(:name => 'TimetableDate').value = date.to_s
      self.class.new(url_from_href(form.action)).tap do |page|
        page.page = form.submit
      end
    end

  protected

    def extract_code_from_anchor anchor
      anchor.text.gsub(/\-\s(Inbound|Outbound)/, '').strip
    end
  end
end
