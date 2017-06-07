module Orderbot
  class Product
    def initialize( spree_product_id )
      @spree_product = Spree::Product.find( spree_product_id )
    end

    def sync
      
    end
  end
  
end
