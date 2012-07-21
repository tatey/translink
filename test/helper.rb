require 'minitest/autorun'
require 'pry'
require 'translink'
require 'webmock/minitest'

include Translink

def fixture path
  File.read File.expand_path("../fixtures/#{path}", __FILE__)
end
