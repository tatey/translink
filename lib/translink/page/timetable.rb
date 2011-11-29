module Translink
  module Page
    class Timetable
      attr_reader :page, :url
      
      def initialize url, page = nil
        @url  = URI.parse url
        @page = page
      end
      
      def page
        @page ||= Mechanize.new.get url.to_s
      end
      
      def route_pages
        anchors.map { |anchor| Route.new absolute_url(anchor['href']) }
      end
      
      def timetable_page date
        form = page.forms[1]        
        form.field_with(:name => 'TimetableDate').value = date.to_s
        self.class.new absolute_url(form.action), form.submit
      end
      
    protected
    
      def absolute_url path
        url.scheme + '://' + url.host + path
      end
    
      def anchors
        page.search 'table tr td:first-child a'
      end      
    end
  end
end
