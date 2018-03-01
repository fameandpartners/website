class AddRecommendedToFabricProducts < ActiveRecord::Migration
  def change
  	add_column :fabrics_products, :recommended, :boolean
  	add_column :fabrics_products, :description, :string
  end
end
