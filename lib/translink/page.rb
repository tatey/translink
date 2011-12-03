module Translink
  class Page
    attr_accessor :page, :url
    
    def initialize url
      @url = URI.parse url
    end
        
    def page
      @page ||= Mechanize.new.get url.to_s
    end
    
  protected
  
    def url_from_href href
      url.scheme + '://' + url.host + href
    end
  end
end
