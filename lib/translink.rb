require 'dm-core'
require 'dm-migrations'
require 'mechanize'
require 'uri'

module Translink
  module Command
  end

  module Crawler
  end
end

require 'translink/version'
require 'translink/crawlers/try'
require 'translink/crawlers/route_page'
require 'translink/crawlers/timetable_page'
require 'translink/crawlers/trip_page'
require 'translink/cli'
require 'translink/commands/help'
require 'translink/commands/route'
require 'translink/commands/timetable'
require 'translink/commands/version'
require 'translink/db'
require 'translink/direction'
require 'translink/model/route'
require 'translink/model/stop'
require 'translink/model/stop_time'
require 'translink/model/trip'
require 'translink/page'
require 'translink/page/bus'
require 'translink/page/bus/route'
require 'translink/page/bus/timetable'
require 'translink/page/train'
require 'translink/page/train/route'
require 'translink/page/train/timetable'
require 'translink/page/trip'
