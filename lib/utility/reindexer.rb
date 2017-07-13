# usage:
# Utility::Reindexer.reindex
module Utility
  class Reindexer

    def self.reindex
      Tire.index(configatron.elasticsearch.indices.spree_products) do
        delete
        import Spree::Product.all
      end

      Products::ColorVariantsIndexer.index!
    end
  end
end
