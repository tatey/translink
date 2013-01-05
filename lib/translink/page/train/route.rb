module Translink
  class Page::Train::Route < Page
    DIRECTIONS = {
      'downward' => Direction::REGULAR,
      'upward'   => Direction::GOOFY
    }

    attr_reader :short_name

    def initialize url, short_name
      super url
      @short_name = short_name
    end

    def date
      Date.parse page.search('div#content-left-column p.print-only').first.text.sub('Date: ', '')
    end

    def long_name
      page.search('div.route-timetable h3').map do |heading|
        heading.text.sub('Towards', '').strip
      end.join(', ')
    end

    def route_id
      short_name.downcase
    end

    def route_type
      2
    end

    def trip_pages
      page.search('a.map-link-top').select do |anchor|
        date_from_anchor(anchor) == date
      end.map do |anchor|
        Trip.new url_from_href(anchor[:href]), date, direction_from_anchor(anchor)
      end
    end

  protected

    def date_from_anchor anchor
      match = anchor[:href].match /\d{4}-\d{2}-\d{2}$/
      date  = match ? match[0] : '1970-01-01'
      DateTime.parse date
    end

    def direction_from_anchor anchor
      direction = anchor[:href].match(Regexp.union(DIRECTIONS.keys)).to_s
      DIRECTIONS[direction]
    end
  end
end
