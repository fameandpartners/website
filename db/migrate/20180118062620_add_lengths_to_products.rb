class AddLengthsToProducts < ActiveRecord::Migration
  def change
  	add_column :spree_products, :lengths, :jsonb, using: 'column_name::jsonb'
  end
end
