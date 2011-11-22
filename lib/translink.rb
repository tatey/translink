require 'bundler/setup'
require 'dm-core'
require 'mechanize'
require 'uri'

require 'translink/crawler'
require 'translink/model/route'
require 'translink/model/service'
require 'translink/page/route'
require 'translink/page/timetable'
require 'translink/page/trip'

DataMapper.finalize
