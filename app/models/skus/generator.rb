# Create a SKU based on the rules stablished by `custom_item_sku.rb`, `variant_sku.rb` files
# SKU EBNF graph can be found at the `doc/content/sku_format.xhtml` docs folder
# SHOULD be the ONLY source of truth for SKU generation

module Skus
  class Generator
    CUSTOM_MARKER = 'X'.freeze

    # @param [String] style_number. Example: "FPS1234"
    # @param [String] size. Example: "US0/AU4"
    # @param [String, Integer] color_id. Example: "12", 12
    # @param [String] height. Example: "Standard"
    # @param [Array<Integer>] customization_value_ids
    def initialize(style_number:, size:, color_id:, height: '', customization_value_ids: [])
      @style_number            = style_number
      @size                    = size
      @color_id                = color_id
      @height                  = height
      @customization_value_ids = customization_value_ids&.sort
    end

    def call
      base_sku = [style_number, size, color]

      if has_personalization?
        base_sku << [custom, height]
      end

      base_sku.join.delete(' ').upcase
    end

    def style_number
      @style_number.to_s
    end

    def size
      @size.to_s.gsub('/', '')
    end

    def color
      "C#{@color_id}"
    end

    def custom
      Array
        .wrap(@customization_value_ids)
        .map { |vid| "#{CUSTOM_MARKER}#{vid}" }.join.presence || CUSTOM_MARKER
    end

    def height
      "H#{@height.to_s.first}#{@height.to_s.last}"
    end

    # Height is also considered a customization
    private def has_personalization?
      @height.present? || @customization_value_ids.present?
    end
  end
end
