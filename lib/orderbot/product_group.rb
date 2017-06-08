module Orderbot
  class ProductGroup

    def self.sync
      connection = Orderbot::Connection.new
      raw_data = connection.get( '/product_structure.json/' )
      raw_data.first['product_classes'].each do |product_class|
        product_class['categories'].each do |category|
          category['groups'].each do |group|
            group_ar = OrderbotProductGroup.find( :first, conditions: {product_class_id: product_class['product_class_id'],
                                                             category_id: category['category_id'],
                                                             group_id: group['group_id'] } )
            group_ar = OrderbotProductGroup.create( product_class_id: product_class['product_class_id'],
                                                 category_id: category['category_id'],
                                                 group_id: group['group_id']  ) if group_ar.nil?
            group_ar.update_attributes( product_class_name: product_class['product_class_name'],
                                     category_name: category['category_name'],
                                     group_name: group['group_name'] )
          end
        end
      end
    end
  end
end
