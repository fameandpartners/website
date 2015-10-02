module Feeds
  module Presenters
    class TaxonPresenter
      attr_reader :taxon, :product

      def initialize(spree_product, spree_taxon)
        @product = spree_product
        @taxon   = spree_taxon
      end

      def events
      end

      def styles
      end

      def lookbooks
      end
    end
  end
end