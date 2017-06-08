module Orderbot
  class Product
    def initialize( spree_product_id )
      @spree_product = Spree::Product.find( spree_product_id )
    end

    def create
      attribute_hash = create_product_hash
    end

    def self.find_all
      connection = Orderbot::Connection.new
#      puts connection.get( '/product_structure.json/' )
#      puts connection.get( '/products.json/' )
    end
  end

  private
  def create_product_hash
    { reference_product_id: spree_product_id.id,
      group_id: sync }
     
  end
  
end
