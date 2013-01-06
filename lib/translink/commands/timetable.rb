module Translink
  module Command
    class Timetable
      extend Crawler::Try

      BUS_URL   = 'http://jp.translink.com.au/travel-information/network-information/buses/all-timetables'
      TRAIN_URL = 'http://jp.translink.com.au/travel-information/network-information/trains/all-timetables'

      def self.run out, argv
        date = Date.parse argv[0]
        path = File.expand_path argv[1]
        DB.context "sqlite://#{path}", :migrate => true do
          crawl_buses out, date
          crawl_trains out, date
        end
      end

      def self.crawl_buses out, date
        try out do
          page    = Page::Bus::Timetable.timetable_page BUS_URL, date
          crawler = Crawler::TimetablePage.new page
          crawler.crawl out
        end
      end

      def self.crawl_trains out, date
        try out do
          page    = Page::Train::Timetable.timetable_page TRAIN_URL, date
          crawler = Crawler::TimetablePage.new page
          crawler.crawl out
        end
      end
    end
  end
end
