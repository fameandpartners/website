class AddRequiredToFieldToOrder < ActiveRecord::Migration
  def change
    add_column :spree_orders, :required_to, :date
  end
end
