require 'minitest/autorun'
require 'translink'
require 'webmock/minitest'

include Translink

DataMapper.setup :default, 'sqlite::memory:'
DataMapper.auto_migrate!

def fixture path
  File.read File.expand_path("../fixtures/#{path}", __FILE__)
end
