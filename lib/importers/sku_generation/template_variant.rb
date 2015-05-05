require 'active_model'

module Importers
  module SkuGeneration
    class TemplateVariant
      attr_accessor :product, :fabric_card, :size, :colour

      def initialize(product, fabric_card, colour, size)
        @product     = product
        @fabric_card = fabric_card
        @colour      = colour
        @size        = size
      end

      def sku
        [product, fabric_card, colour, size].collect(&:sku_component).join('')
      end

      def valid?
        [fabric_card, colour, size].all?(&:valid?)
      end

      def errors
        [fabric_card, colour, size].collect(&:errors)
      end
    end
  end
end
