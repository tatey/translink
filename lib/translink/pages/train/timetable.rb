module Translink
  module Page
    module Train
      class Timetable < Base
        attr_reader :date

        def self.timetable_page url, date
          new url, date
        end

        def initialize url, date
          super url
          @date = date
        end

        def route_pages
          page.search('table tr td:first-child a').map do |anchor|
            Train::Route.new url_from_anchor(anchor), anchor.text
          end
        end

      protected

        def url_from_anchor anchor
          "#{url_from_href(anchor[:href])}/#{date}"
        end
      end
    end
  end
end
