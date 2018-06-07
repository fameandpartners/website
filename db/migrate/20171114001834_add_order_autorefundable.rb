class AddOrderAutorefundable < ActiveRecord::Migration
  def up
		add_column :spree_orders, :autorefundable, :boolean
	end

	def down
 		remove_column :spree_orders, :autorefundable
	end
end
