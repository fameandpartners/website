module Feeds
  module Presenters
    class VariantPresenter
      attr_reader :variant

      def initialize(spree_variant)
        @variant = spree_variant
        @product = spree_variant.product
      end

      def sku
      end

      def size
      end

      def color
      end

      def zone_price_for(current_site_version)
      end

      def display_price
      end

      def sale_price
      end
    end
  end
end