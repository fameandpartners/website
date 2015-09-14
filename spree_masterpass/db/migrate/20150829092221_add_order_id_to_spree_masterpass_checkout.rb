class AddOrderIdToSpreeMasterpassCheckout < ActiveRecord::Migration
  def change
    add_column :spree_masterpass_checkouts, :order_id, :integer
  end
end
