module Search
  class Indexes
    def self.build
      Tire.index(:spree_products) do
        delete
        import Spree::Product.all
      end
      Products::ColorVariantsIndexer.index!
    end
  end
end
