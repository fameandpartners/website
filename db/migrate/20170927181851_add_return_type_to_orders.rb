class AddReturnTypeToOrders < ActiveRecord::Migration
   	def up
		add_column :spree_orders, :return_type, :string
	end

	def down
 		remove_column :spree_orders, :return_type
	end
end
