class AddOrderbotSuccessOrders < ActiveRecord::Migration
 	def up
		add_column :spree_orders, :orderbot_success, :boolean,:null => false, :default => false
	end

	def down
 		remove_column :spree_orders, :orderbot_success, :boolean
	end
end
