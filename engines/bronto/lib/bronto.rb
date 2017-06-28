module Bronto
  mattr_accessor :api_token, :wsdl_path

  def self.setup
    yield self
  end
end

require 'bronto/engine'
require 'bronto/client'
