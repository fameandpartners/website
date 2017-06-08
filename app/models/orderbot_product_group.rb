class OrderbotProductGroup < ActiveRecord::Base
  attr_accessible :category_id, :category_name, :group_id, :group_name, :product_class_id, :product_class_name
  has_one :product_to_orderbot_product_group
end
