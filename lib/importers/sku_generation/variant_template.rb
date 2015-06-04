require 'active_model'

module Importers
  module SkuGeneration
    class VariantTemplate
      attr_accessor :product, :fabric_card, :size, :colour

      def initialize(product, fabric_card, colour, size)
        @product     = product
        @fabric_card = fabric_card
        @colour      = colour
        @size        = size
      end

      def sku
        sku_components.join('')
      end

      def valid?
        [fabric_card, colour, size].all?(&:valid?) && sku_components.all?(&:present?)
      end

      def errors
        [fabric_card, colour, size].collect(&:errors)
      end

      private
      def sku_components
        [product, fabric_card, colour, size].collect(&:sku_component)
      end
    end
  end
end
