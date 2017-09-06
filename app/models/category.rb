class Category < ActiveRecord::Base
    has_many :spree_products, foreign_key: :category_id , inverse_of: :product
end
