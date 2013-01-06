module Translink
  module Command
    class Help
      def self.run out, argv
        out.puts <<-HELP
Usage: translink <COMMAND> [ARGS]

Fetch all bus and train data:
  timetable <DATE> <DB_PATH>
  timetable 2013-01-07 ~/gtfs.sqlite3

Fetch an single route's data:
  route <ROUTE_TYPE> <ROUTE_NAME> <ROUTE_URL> <DB_PATH>
  route bus "Teneriffe, Newstead, Valley, City, Cultural Centre, West End" http://jp.translink.com.au/travel-information/network-information/buses/CGLD/2013-01-07, ~/gtfs.sqlite3
  route train "Ferny Grove" http://jp.translink.com.au/travel-information/network-information/trains/ferny-grove/2013-01-07 ~/gtfs.sqlite3

Print the current version:
  version
        HELP
      end
    end
  end
end
