class AddRecommendedToProductColorValue < ActiveRecord::Migration
  def change
    add_column :product_color_values, :active, :boolean, default: true
    add_column :product_color_values, :custom, :boolean, default: false
  end
end
