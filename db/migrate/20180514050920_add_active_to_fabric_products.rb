class AddActiveToFabricProducts < ActiveRecord::Migration
  def change
  	  add_column :fabrics_products, :active, :boolean, default: true
  end
end
