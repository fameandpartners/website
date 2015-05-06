require 'active_model'

module Importers
  module SkuGeneration
    class TemplateProduct
      attr_accessor :style_number, :style_name, :fabric_card, :base_sku_code, :base_sizes

      def initialize(style_number, style_name)
        @style_number = style_number
        @style_name = style_name
      end

      def sku_component
        style_number
      end

      def variants
        @variants ||= fabric_card.colours.flat_map do |colour|
          base_sizes.collect do |size|
            TemplateVariant.new(
              self,
              fabric_card,
              colour,
              size
            )
          end
        end
      end

      def final_skus
        variants.collect &:sku
      end
    end
  end
end
