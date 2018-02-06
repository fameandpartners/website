class AddLengthsToProducts < ActiveRecord::Migration
  def change
  	add_column :spree_products, :lengths, :jsonb
  end
end
