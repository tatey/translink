module Translink
  class Crawler
    MAX_RETRY_COUNT = 2 # Maximum number of times to attempt a HTTP request.
    SLEEP_DURATION  = 5 # Base amount of time to sleep in seconds before retrying.

    attr_accessor :out
    attr_reader   :url

    def initialize url
      @url = URI.parse url
      @out = $stdout
    end

    def crawl date
      timetable_page = Page::Timetable.new(url.to_s).timetable_page date
      timetable_page.route_pages.each do |route_page|
        crawl_route_page route_page
      end
    end

    def crawl_route_page route_page, retry_count = 0
      route_model = Model::Route.find_or_add_route_from_route_page route_page
      route_page.trip_pages.each do |trip_page|
        crawl_trip_page route_model, trip_page
      end
    rescue Mechanize::ResponseCodeError, Page::UnexpectedParserError => exception
      if retry_count <= MAX_RETRY_COUNT
        sleep SLEEP_DURATION * retry_count
        crawl_route_page route_page, retry_count + 1
      else
        out.puts "Skipping route page (#{route_page.url}) because of #{exception}"
      end
    end

    def crawl_trip_page route_model, trip_page, retry_count = 0
      trip_model = route_model.add_trip_from_trip_page trip_page
      trip_model.add_stop_times_from_stop_time_pages trip_page.stop_times
    rescue Mechanize::ResponseCodeError, Page::UnexpectedParserError => exception
      if retry_count <= MAX_RETRY_COUNT
        sleep SLEEP_DURATION * retry_count
        crawl_trip_page route_model, trip_page, retry_count + 1
      else
        out.puts "Skipping trip page (#{trip_page.url}) because of #{exception}"
      end
    end
  end
end
