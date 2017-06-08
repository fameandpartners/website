class ProductToOrderbotProductGroup < ActiveRecord::Base
  attr_accessible :orderbot_product_group_id, :product_id
  belongs_to :orderbot_product_group
  belongs_to :spree_product
end
