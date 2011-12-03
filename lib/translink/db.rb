module Translink
  class DB
    attr_reader :name, :uri
    
    def initialize uri, &block
      @uri  = uri
      @name = :default
      DataMapper.setup name, uri
      DataMapper.repository name do
        DataMapper.finalize
        DataMapper.auto_migrate!
      end
      use &block if block
    end
    
    def use &block
      DataMapper.repository(name) { block.call }
    end
  end
end
