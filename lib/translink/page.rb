module Translink
  class Page
    class UnexpectedParserError < StandardError
    end

    USER_AGENT = "Mozilla/5.0 (Translink/#{VERSION} Ruby/#{RUBY_VERSION} (https://github.com/tatey/translink))"

    attr_accessor :agent, :page, :url

    def initialize url
      @agent = Mechanize.new.tap { |mechanize| mechanize.user_agent = USER_AGENT }
      @url   = URI.parse url
    end

    def page
      @page ||= begin
        page = agent.get url.to_s
        if page.instance_of? Mechanize::Page
          page
        else
          raise UnexpectedParserError, "Expected instance of Mechanize::Page. Got #{page.class}"
        end
      end
    end

  protected

    def url_from_href href
      url.scheme + '://' + url.host + href
    end
  end
end
