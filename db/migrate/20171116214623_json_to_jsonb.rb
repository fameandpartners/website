class JsonToJsonb < ActiveRecord::Migration
  	def change
  		change_column :spree_products, :customizations, 'jsonb USING CAST(customizations as jsonb)'
	end
end
