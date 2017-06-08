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
      puts connection.get( '/products.json/' )
    end

    private
    def create_product_hash
      return { reference_product_id: @spree_product.id,
               group_id: @spree_product.orderbot_product_group.group_id,
               create_bom: false,
               create_purchase_unit: false,
               name: @spree_product.name,
               description: @spree_product.description,
               sku: @spree_product.sku,
               base_price: @spree_product.price,
               units_of_measure: 'each',
               unit_of_measure_type_id: 1,
               weight: 8.0,
               shipping_units_of_measure_type_id: 1,
               taxable: false,
               min_quatity: 1,
               active: true,
               is_parent: false,
               upc: @spree_product.id.to_s
      }
      
    end
  end
  
end
