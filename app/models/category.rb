class Category < ActiveRecord::Base
    attr_accessible :category, :subcategory
    has_many :spree_products, foreign_key: :category_id , inverse_of: :product
end
