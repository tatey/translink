module Translink
  module Command
    class Route
      # ROUTE_TYPES = {
      #   'bus'   => Page::Bus::Route,
      #   'train' => Page::Train::Route
      # }

      def self.run out, argv
        paath = File.expand_path argv[3]
        url   = argv[2]
        name  = argv[1]
        type  = ROUTE_TYPES.fetch argv[0] do
          out.puts 'Unknown route type. See help.'
          exit
        end
        DB.context "sqlite://#{path}" do
          page    = type.new url
          crawler = Crawler::RoutePage.new page
          crawler.crawl
        end
      end
    end
  end
end
