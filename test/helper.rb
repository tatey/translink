require 'minitest/autorun'
require 'translink'
require 'webmock/minitest'

include Translink

def fixture name
  File.read File.expand_path("../fixtures/#{name}", __FILE__)
end
