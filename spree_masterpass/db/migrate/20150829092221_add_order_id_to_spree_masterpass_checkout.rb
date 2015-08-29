class AddOrderIdToSpreeMasterpassCheckout < ActiveRecord::Migration
  def change
    add_column :spree_masterpass_checkouts, :order_id, :string
  end
end
