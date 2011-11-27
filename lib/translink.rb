require 'bundler/setup'
require 'dm-core'
require 'dm-migrations'
require 'mechanize'
require 'uri'

require 'translink/cli'
require 'translink/crawler'
require 'translink/model/route'
require 'translink/model/service'
require 'translink/page/route'
require 'translink/page/timetable'
require 'translink/page/trip'

DataMapper.finalize
