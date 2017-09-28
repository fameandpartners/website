class StoreDeliveryDateForLineItems < ActiveRecord::Migration
  	def up
		add_column :spree_line_items, :delivery_date, :string
	end

	def down
 		remove_column :spree_line_items, :delivery_date
	end
end
