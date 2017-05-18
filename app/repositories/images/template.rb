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

      # @param [Hash{Symbol => Object}] options
      # @option options [Integer] :id. ID of the `Spree::Image` if it's persisted on the database
      # @option options [Integer] :position. Default: 0
      # @option options [String] :original. URL for the "original" image size version
      # @option options [String] :large. URL for the "large" image size version
      # @option options [String] :xlarge. URL for the "xlarge" image size version
      # @option options [String] :small. URL for the "small" image size version
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
        binding.pry
        {
          id:       id,
          position: position,
          original: original,
          large:    large,
          xlarge:   xlarge,
          small:    small
        }
      end

      def marshal_load(data)
        self.id       = data[:id]
        self.position = data[:position] || 0
        self.original = data[:original] || DEFAULT_URL
        self.large    = data[:large] || DEFAULT_URL
        self.xlarge   = data[:xlarge] || DEFAULT_URL
        self.small    = data[:small] || DEFAULT_URL
      end

      def self.default
        self.new
      end
    end
  end
end
