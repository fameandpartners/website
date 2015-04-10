class AddCustomRequestToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :customer_notes, :text, :null => true
  end
end
