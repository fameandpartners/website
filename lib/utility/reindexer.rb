module Utility
  class Reindexer

    def self.reindex
      Tire.index(:spree_products) do
        delete
        import Spree::Product.all
      end
      Products::ColorVariantsIndexer.index!
    end


  end
end