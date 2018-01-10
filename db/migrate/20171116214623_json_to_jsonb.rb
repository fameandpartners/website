class JsonToJsonb < ActiveRecord::Migration
  	def change
  		change_column :spree_products, :customizations, :jsonb, using: 'column_name::jsonb'
	end
end
