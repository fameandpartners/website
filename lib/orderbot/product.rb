module Orderbot
  class Product
    def initialize( spree_product_id )
      @spree_product = Spree::Product.find( spree_product_id )
    end

    def sync
    end

    def self.find_all
      connection = Orderbot::Connection.new
      puts connection.get( '/products.json/' )
    end
  end
end
