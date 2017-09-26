class AddOrderbotSuccessOrders < ActiveRecord::Migration
 	def up
		add_column :spree_orders, :orderbot_synced, :boolean
	end

	def down
 		remove_column :spree_orders, :orderbot_synced
	end
end
