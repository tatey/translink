module Translink
  module DB
    def self.context uri, options = {}
      DataMapper.setup :default, uri
      DataMapper.repository :default do
        DataMapper.finalize
        DataMapper.auto_migrate! if options[:migrate]
        yield if block_given?
      end
    end
  end
end
