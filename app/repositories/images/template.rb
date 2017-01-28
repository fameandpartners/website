module Repositories
  module Images
    class Template
      DEFAULT_URL = 'noimage/product.png'.freeze

      attr_reader :id,
                  :position,
                  :original,
                  :large,
                  :xlarge,
                  :small

      def initialize(options = {})
        @id       = options[:id]
        @position = options[:position] || 0
        @original = options[:original] || DEFAULT_URL
        @large    = options[:large] || DEFAULT_URL
        @xlarge   = options[:xlarge] || DEFAULT_URL
        @small    = options[:small] || DEFAULT_URL
      end

      # To offer compatibility with `OpenStruct#marshal_dump`
      # Used in `UserCart::CartProductPresenter#serialize`
      # @return [Repositories::Images::Template]
      def marshal_dump
        {
          id:       id,
          position: position,
          original: original,
          large:    large,
          xlarge:   xlarge,
          small:    small
        }
      end

      def self.default
        self.new
      end
    end
  end
end
