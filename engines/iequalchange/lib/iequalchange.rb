require 'iequalchange/engine'

module Iequalchange
  autoload :VERSION,       'iequalchange/version'
  autoload :Config,        'iequalchange/config'
  autoload :Configuration, 'iequalchange/config'
  autoload :Cypher,        'iequalchange/cypher'

  class << self
    include Configuration

    def configure(options = {}, &block)
      Config.configure(options, &block)
    end

    def load(*args)
      Config.load(*args)
    end
  end
end
