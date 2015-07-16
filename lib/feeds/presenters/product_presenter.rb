module Feeds
  module Presenters
    class ProductPresenter
      attr_reader :product, :master

      def initialize(spree_product)
        @product = spree_product
        @product = spree_product.master
      end

      def id
      end

      def name
      end

      def sku
      end

      # TH: on-demand means never having to say you're out-of-stock
      # variant.in_stock? ? 'in stock' : 'out of stock',
      def availability
        'in stock'
      end

      def title
      end

      def images
      end

      def description
      end

      def weight
        # master.weight || product.weight || product.property('weight')
      end

      def taxons
      end
    end
  end
end