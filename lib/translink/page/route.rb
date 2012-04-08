module Translink
  class Page::Route < Page
    def code
      page.search('div#contentleftCol table th:nth-child(2)').first.text.strip
    end
    
    def date
      Date.parse page.search('div#contentleftCol div.content p span').text
    end
          
    def direction
      page.search('div#contentleftCol div.content p').text.downcase.match(/(\S+)$/).captures.first
    end
    
    def name
      page.search('div#headingBar h1').text
    end
    
    def translink_id
      url.path.match(/([^\/]+)$/).captures.last
    end
    
    def trip_pages
      page.search('table:not(:last-child) tfoot a').map do |anchor|
        Trip.new url_from_href(anchor[:href])
      end
    end
  end
end
