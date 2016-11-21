require 'erb'
require 'yaml'

module Iequalchange
  class Config
    SCRIPT_SRC_PATH = 'static/js/load'.freeze

    attr_reader :config

    def initialize(options={})
      @config = {
        id:  ENV.fetch('IEC_ID').freeze,
        key: ENV.fetch('IEC_KEY').freeze,
        url: ENV.fetch('IEC_URL').freeze,
        script_src_path: SCRIPT_SRC_PATH
      }
    end

  end
end
